import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../models/school.dart';
import '../services/firebase_service.dart';

class EditSchoolScreen extends StatefulWidget {
  final School school;

  const EditSchoolScreen({super.key, required this.school});

  @override
  State<EditSchoolScreen> createState() => _EditSchoolScreenState();
}

class _EditSchoolScreenState extends State<EditSchoolScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _adminUsernameController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  final _logoUrlController = TextEditingController();
  
  String _logoBase64 = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.school.name;
    _locationController.text = widget.school.location;
    _adminUsernameController.text = widget.school.adminUsername;
    _adminPasswordController.text = widget.school.adminPassword;
    
    // تحقق إذا كان الشعار URL أم Base64
    if (widget.school.logo.startsWith('http')) {
      _logoUrlController.text = widget.school.logo;
    } else {
      _logoBase64 = widget.school.logo;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _adminUsernameController.dispose();
    _adminPasswordController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        Uint8List? fileBytes = result.files.first.bytes;
        if (fileBytes != null) {
          // تحقق من حجم الصورة
          if (fileBytes.length > 500 * 1024) { // 500KB
            _showErrorDialog('الصورة كبيرة جداً. يرجى اختيار صورة أصغر من 500KB');
            return;
          }
          
          setState(() {
            _logoBase64 = base64Encode(fileBytes);
            _logoUrlController.clear(); // مسح URL إذا تم رفع صورة
          });
          
          print('حجم الصورة: ${fileBytes.length} bytes');
          print('حجم Base64: ${_logoBase64.length} characters');
        }
      }
    } catch (e) {
      _showErrorDialog('خطأ في اختيار الشعار: $e');
    }
  }

  Future<void> _updateSchool() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedSchool = School(
        id: widget.school.id,
        name: _nameController.text.trim(),
        logo: _logoBase64.isNotEmpty ? _logoBase64 : _logoUrlController.text.trim(),
        location: _locationController.text.trim(),
        adminUsername: _adminUsernameController.text.trim(),
        adminPassword: _adminPasswordController.text.trim(),
        range: widget.school.range,
        delayMinutes: widget.school.delayMinutes,
        createdAt: widget.school.createdAt,
        updatedAt: DateTime.now(),
      );

      await FirebaseService.updateSchool(widget.school.id, updatedSchool);
      
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث بيانات المدرسة بنجاح')),
        );
      }
    } catch (e) {
      _showErrorDialog('خطأ في تحديث بيانات المدرسة: $e');
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
        title: const Text('تعديل بيانات المدرسة'),
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
              // معلومات المدرسة
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'معلومات المدرسة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // اسم المدرسة
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم المدرسة *',
                          prefixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم المدرسة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // موقع المدرسة
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'موقع المدرسة *',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال موقع المدرسة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // شعار المدرسة
                      const Text(
                        'شعار المدرسة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // خيار 1: رفع صورة
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickLogo,
                              icon: const Icon(Icons.image),
                              label: const Text('رفع صورة'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (_logoBase64.isNotEmpty)
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, size: 30),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // خيار 2: إدخال URL
                      const Text(
                        'أو أدخل رابط الشعار:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _logoUrlController,
                        decoration: const InputDecoration(
                          labelText: 'رابط الشعار',
                          prefixIcon: Icon(Icons.link),
                          border: OutlineInputBorder(),
                          hintText: 'https://example.com/logo.png',
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _logoBase64 = ''; // مسح Base64 إذا تم إدخال URL
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // معلومات المسؤول
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'معلومات مسؤول المدرسة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // اسم المستخدم
                      TextFormField(
                        controller: _adminUsernameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم المستخدم *',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم المستخدم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // كلمة المرور
                      TextFormField(
                        controller: _adminPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور *',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
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
                  onPressed: _isLoading ? null : _updateSchool,
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
                          'تحديث بيانات المدرسة',
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
