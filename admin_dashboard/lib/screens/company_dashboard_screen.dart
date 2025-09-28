import 'package:flutter/material.dart';
import '../models/school.dart';
import '../services/firebase_service.dart';
import 'create_school_screen.dart';
import 'edit_school_screen.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  List<School> _schools = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final schools = await FirebaseService.getSchools();
      setState(() {
        _schools = schools;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _schools = []; // قائمة فارغة في حالة الخطأ
      });
      
      // إذا كان الخطأ بسبب عدم الاتصال بـ Firebase، اعرض رسالة مختلفة
      if (e.toString().contains('offline') || e.toString().contains('unavailable')) {
        _showErrorDialog('لا يمكن الاتصال بـ Firebase. تأكد من:\n1. اتصال الإنترنت\n2. إعداد Firebase بشكل صحيح\n3. تحديث ملف firebase_options.dart');
      } else {
        _showErrorDialog('خطأ في تحميل المدارس: $e');
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

  Future<void> _editSchool(School school) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSchoolScreen(school: school),
      ),
    );

    if (result == true) {
      _loadSchools();
    }
  }

  Future<void> _deleteSchool(School school) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف مدرسة "${school.name}"؟'),
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
        await FirebaseService.deleteSchool(school.id);
        _loadSchools();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف المدرسة بنجاح')),
        );
      } catch (e) {
        _showErrorDialog('خطأ في حذف المدرسة: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبورد الشركة'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadSchools,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // إحصائيات سريعة
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'إجمالي المدارس',
                          _schools.length.toString(),
                          Icons.school,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'مدارس نشطة',
                          _schools.length.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // قائمة المدارس
                Expanded(
                  child: _schools.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'لا توجد مدارس مسجلة',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'اضغط على + لإضافة مدرسة جديدة',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _schools.length,
                          itemBuilder: (context, index) {
                            final school = _schools[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    school.name.isNotEmpty
                                        ? school.name[0].toUpperCase()
                                        : 'م',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  school.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('الموقع: ${school.location}'),
                                    Text('المسؤول: ${school.adminUsername}'),
                                    Text(
                                      'تاريخ الإنشاء: ${school.createdAt.day}/${school.createdAt.month}/${school.createdAt.year}',
                                    ),
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
                                      _editSchool(school);
                                    } else if (value == 'delete') {
                                      _deleteSchool(school);
                                    }
                                  },
                                ),
                                onTap: () {
                                  // TODO: عرض تفاصيل المدرسة
                                },
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
              builder: (context) => const CreateSchoolScreen(),
            ),
          );
          
          if (result == true) {
            _loadSchools();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
