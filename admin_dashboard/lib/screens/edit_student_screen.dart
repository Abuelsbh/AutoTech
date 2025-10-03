import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/class_section.dart';
import '../services/firebase_service.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  
  List<ClassSection> _classes = [];
  String? _selectedClassId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await FirebaseService.getClassSections(widget.student.schoolId);
      setState(() {
        _classes = classes;
        _initializeFields();
      });
    } catch (e) {
      _showErrorDialog('خطأ في تحميل الفصول: $e');
    }
  }

  void _initializeFields() {
    _idNumberController.text = widget.student.idNumber;
    _nameController.text = widget.student.name;
    _guardianNameController.text = widget.student.guardianName;
    _guardianPhoneController.text = widget.student.guardianPhone;
    
    // البحث عن الفصل الحالي في قائمة الفصول
    final currentClass = _classes.firstWhere(
      (c) => c.name == widget.student.classSection,
      orElse: () => ClassSection(
        id: '',
        schoolId: widget.student.schoolId,
        name: widget.student.classSection,
        description: '',
        createdAt: DateTime.now(),
      ),
    );
    _selectedClassId = currentClass.id;
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    _nameController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedClass = _classes.firstWhere(
        (c) => c.id == _selectedClassId,
      );

      final updatedStudent = Student(
        id: widget.student.id,
        schoolId: widget.student.schoolId,
        idNumber: _idNumberController.text.trim(),
        name: _nameController.text.trim(),
        classSection: selectedClass.name,
        guardianName: _guardianNameController.text.trim(),
        guardianPhone: _guardianPhoneController.text.trim(),
        createdAt: widget.student.createdAt,
      );

      await FirebaseService.updateStudent(widget.student.id, updatedStudent);
      
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث بيانات الطالب بنجاح')),
        );
      }
    } catch (e) {
      _showErrorDialog('خطأ في تحديث بيانات الطالب: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل بيانات الطالب'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'معلومات الطالب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // رقم الهوية
                      TextFormField(
                        controller: _idNumberController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهوية *',
                          prefixIcon: Icon(Icons.badge),
                          border: OutlineInputBorder(),
                          hintText: '1234567890',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال رقم الهوية';
                          }
                          if (value.length != 10) {
                            return 'رقم الهوية يجب أن يكون 10 أرقام';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // اسم الطالب
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم الطالب *',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          hintText: 'أحمد محمد علي',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم الطالب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // الفصل والشعبة
                      DropdownButtonFormField<String>(
                        value: _selectedClassId,
                        decoration: const InputDecoration(
                          labelText: 'الفصل والشعبة *',
                          prefixIcon: Icon(Icons.class_),
                          border: OutlineInputBorder(),
                        ),
                        items: _classes.map((classSection) {
                          return DropdownMenuItem(
                            value: classSection.id,
                            child: Text(classSection.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedClassId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار الفصل';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'معلومات الوصي',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // اسم الوصي
                      TextFormField(
                        controller: _guardianNameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم الوصي *',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                          hintText: 'محمد علي',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم الوصي';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // رقم جوال الوصي
                      TextFormField(
                        controller: _guardianPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'رقم جوال الوصي *',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                          hintText: '01012345678',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال رقم جوال الوصي';
                          }
                          if (value.length < 10) {
                            return 'رقم الجوال غير صحيح';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // زر التحديث
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'تحديث بيانات الطالب',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
