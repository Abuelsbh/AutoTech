import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/firebase_service.dart';
import '../services/excel_service.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart';

class StudentManagementScreen extends StatefulWidget {
  final String schoolId;

  const StudentManagementScreen({
    super.key,
    required this.schoolId,
  });

  @override
  State<StudentManagementScreen> createState() => _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  List<Student> _students = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final students = await FirebaseService.getStudents(widget.schoolId);
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _students = []; // قائمة فارغة في حالة الخطأ
      });
      
      // إذا كان الخطأ بسبب عدم الاتصال بـ Firebase، اعرض رسالة مختلفة
      if (e.toString().contains('offline') || e.toString().contains('unavailable')) {
        _showErrorDialog('لا يمكن الاتصال بـ Firebase. تأكد من:\n1. اتصال الإنترنت\n2. إعداد Firebase بشكل صحيح\n3. تحديث ملف firebase_options.dart');
      } else {
        _showErrorDialog('خطأ في تحميل الطلاب: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFromExcel() async {
    try {
      final studentsData = await ExcelService.readStudentsFromExcel();
      
      if (studentsData.isNotEmpty) {
        // استخراج الفصول الفريدة لعرضها في رسالة التأكيد
        final uniqueClassSections = ExcelService.extractUniqueClassSections(studentsData);
        
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تأكيد الرفع'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('سيتم رفع ${studentsData.length} طالب.'),
                const SizedBox(height: 8),
                const Text('الفصول الموجودة في الملف:'),
                const SizedBox(height: 4),
                ...uniqueClassSections.map((className) => 
                  Text('• $className', style: const TextStyle(fontSize: 12))
                ),
                const SizedBox(height: 8),
                const Text(
                  'ملاحظة: سيتم إنشاء الفصول الجديدة تلقائياً إذا لم تكن موجودة.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                const Text('هل تريد المتابعة؟'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('متابعة'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await FirebaseService.uploadStudentsFromExcel(widget.schoolId, studentsData);
          _loadStudents();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم رفع ${studentsData.length} طالب بنجاح')),
          );
        }
      }
    } catch (e) {
      _showErrorDialog('خطأ في رفع ملف Excel: $e');
    }
  }

  Future<void> _downloadTemplate() async {
    try {
      await ExcelService.downloadStudentsTemplate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحميل ملف النموذج')),
      );
    } catch (e) {
      _showErrorDialog('خطأ في تحميل النموذج: $e');
    }
  }

  Future<void> _editStudent(Student student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(student: student),
      ),
    );

    if (result == true) {
      _loadStudents();
    }
  }

  Future<void> _deleteStudent(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الطالب "${student.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseService.deleteStudent(student.id);
        _loadStudents();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الطالب بنجاح')),
        );
      } catch (e) {
        _showErrorDialog('خطأ في حذف الطالب: $e');
      }
    }
  }

  List<Student> get _filteredStudents {
    if (_searchQuery.isEmpty) return _students;
    
    return _students.where((student) {
      return student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             student.idNumber.contains(_searchQuery) ||
             student.classSection.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             student.guardianName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // شريط البحث والأزرار
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'البحث في الطلاب...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _downloadTemplate,
                        icon: const Icon(Icons.download),
                        label: const Text('تحميل النموذج'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _uploadFromExcel,
                        icon: const Icon(Icons.upload),
                        label: const Text('رفع Excel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // قائمة الطلاب
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredStudents.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'لا توجد طلاب مسجلين',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'اضغط على + لإضافة طالب جديد',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = _filteredStudents[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  student.name.isNotEmpty
                                      ? student.name[0].toUpperCase()
                                      : 'ط',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                student.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('رقم الهوية: ${student.idNumber}'),
                                  Text('الفصل: ${student.classSection}'),
                                  Text('الوصي: ${student.guardianName}'),
                                  Text('جوال الوصي: ${student.guardianPhone}'),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('تعديل'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('حذف', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editStudent(student);
                                  } else if (value == 'delete') {
                                    _deleteStudent(student);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentScreen(schoolId: widget.schoolId),
            ),
          );
          
          if (result == true) {
            _loadStudents();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
