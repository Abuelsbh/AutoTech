import 'package:flutter/material.dart';
import '../models/student.dart';
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
  final _classSectionController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _idNumberController.text = widget.student.idNumber;
    _nameController.text = widget.student.name;
    _classSectionController.text = widget.student.classSection;
    _guardianNameController.text = widget.student.guardianName;
    _guardianPhoneController.text = widget.student.guardianPhone;
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    _nameController.dispose();
    _classSectionController.dispose();
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
      final updatedStudent = Student(
        id: widget.student.id,
        schoolId: widget.student.schoolId,
        idNumber: _idNumberController.text.trim(),
        name: _nameController.text.trim(),
        classSection: _classSectionController.text.trim(),
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

                      // الصف والشعبة
                      TextFormField(
                        controller: _classSectionController,
                        decoration: const InputDecoration(
                          labelText: 'الصف والشعبة *',
                          prefixIcon: Icon(Icons.class_),
                          border: OutlineInputBorder(),
                          hintText: 'grade1 A, grade1.1, الصف الأول أ',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الصف والشعبة';
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
