import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../models/school.dart';
import '../services/firebase_service.dart';
import 'location_picker_screen.dart';

class CreateSchoolScreen extends StatefulWidget {
  const CreateSchoolScreen({super.key});

  @override
  State<CreateSchoolScreen> createState() => _CreateSchoolScreenState();
}

class _CreateSchoolScreenState extends State<CreateSchoolScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _adminUsernameController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  final _logoUrlController = TextEditingController();
  
  String _logoBase64 = '';
  double? _selectedLatitude;
  double? _selectedLongitude;
  String _selectedAddress = '';
  bool _isLoading = false;

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
          });
          
          print('حجم الصورة: ${fileBytes.length} bytes');
          print('حجم Base64: ${_logoBase64.length} characters');
        }
      }
    } catch (e) {
      _showErrorDialog('خطأ في اختيار الشعار: $e');
    }
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialLatitude: _selectedLatitude,
          initialLongitude: _selectedLongitude,
          initialAddress: _selectedAddress,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLatitude = result['latitude'];
        _selectedLongitude = result['longitude'];
        _selectedAddress = result['address'];
        _locationController.text = _selectedAddress;
      });
    }
  }

  Future<void> _createSchool() async {
    if (!_formKey.currentState!.validate()) return;

    // التحقق من وجود الشعار
    if (_logoBase64.isEmpty && _logoUrlController.text.trim().isEmpty) {
      _showErrorDialog('يرجى اختيار شعار للمدرسة');
      return;
    }

    // التحقق من اختيار الموقع
    if (_selectedLatitude == null || _selectedLongitude == null) {
      _showErrorDialog('يرجى اختيار موقع المدرسة من الخريطة');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final school = School(
        id: '',
        name: _nameController.text.trim(),
        logo: _logoBase64.isNotEmpty ? _logoBase64 : _logoUrlController.text.trim(),
        location: _locationController.text.trim(),
        latitude: _selectedLatitude,
        longitude: _selectedLongitude,
        adminUsername: _adminUsernameController.text.trim(),
        adminPassword: _adminPasswordController.text.trim(),
        createdAt: DateTime.now(),
      );

      await FirebaseService.createSchool(school);
      
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء المدرسة بنجاح')),
        );
      }
    } catch (e) {
      _showErrorDialog('خطأ في إنشاء المدرسة: $e');
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
        title: const Text('إنشاء مدرسة جديدة'),
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
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'موقع المدرسة *',
                          prefixIcon: const Icon(Icons.location_on),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: _pickLocation,
                            icon: const Icon(Icons.map),
                            tooltip: 'اختيار من الخريطة',
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار موقع المدرسة من الخريطة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // شعار المدرسة
                      const Text(
                        'شعار المدرسة *',
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(_logoBase64),
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                          // تحديث قيمة URL
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
                          hintText: 'school_1',
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

              // زر الإنشاء
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createSchool,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'إنشاء المدرسة',
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
