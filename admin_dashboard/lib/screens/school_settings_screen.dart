import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class SchoolSettingsScreen extends StatefulWidget {
  final String schoolId;

  const SchoolSettingsScreen({
    super.key,
    required this.schoolId,
  });

  @override
  State<SchoolSettingsScreen> createState() => _SchoolSettingsScreenState();
}

class _SchoolSettingsScreenState extends State<SchoolSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rangeController = TextEditingController(text: '100');
  final _delayController = TextEditingController(text: '15');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSchoolSettings();
  }

  @override
  void dispose() {
    _rangeController.dispose();
    _delayController.dispose();
    super.dispose();
  }

  Future<void> _loadSchoolSettings() async {
    try {
      final school = await FirebaseService.getSchool(widget.schoolId);
      if (school != null && mounted) {
        setState(() {
          _rangeController.text = school.range.toString();
          _delayController.text = school.delayMinutes.toString();
        });
      } else {
        // إذا لم توجد المدرسة، استخدم القيم الافتراضية
        if (mounted) {
          setState(() {
            _rangeController.text = '100';
            _delayController.text = '15';
          });
        }
      }
    } catch (e) {
      // في حالة الخطأ، استخدم القيم الافتراضية ولا تظهر رسالة خطأ
      if (mounted) {
        setState(() {
          _rangeController.text = '100';
          _delayController.text = '15';
        });
      }
      print('تحذير: لا يمكن الاتصال بـ Firebase، استخدام القيم الافتراضية');
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final range = double.parse(_rangeController.text);
      final delayMinutes = int.parse(_delayController.text);
      
      // تحديث إعدادات المدرسة في Firebase
      await FirebaseService.updateSchoolSettings(widget.schoolId, range, delayMinutes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        // إذا كان الخطأ بسبب عدم الاتصال بـ Firebase، اعرض رسالة مختلفة
        if (e.toString().contains('offline') || e.toString().contains('unavailable')) {
          _showErrorDialog('لا يمكن الاتصال بـ Firebase. تأكد من:\n1. اتصال الإنترنت\n2. إعداد Firebase بشكل صحيح\n3. تحديث ملف firebase_options.dart');
        } else {
          _showErrorDialog('خطأ في حفظ الإعدادات: $e');
        }
      }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // إعدادات النطاق
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'إعدادات النطاق',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _rangeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'مسافة النطاق (متر)',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                          suffixText: 'متر',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال مسافة النطاق';
                          }
                          final range = double.tryParse(value);
                          if (range == null || range <= 0) {
                            return 'يرجى إدخال رقم صحيح أكبر من الصفر';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'المسافة القصوى التي يمكن للطالب أن يكون فيها من المدرسة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // إعدادات التنبيه
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'إعدادات التنبيه',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _delayController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'وقت التنبيه (دقيقة)',
                          prefixIcon: Icon(Icons.timer),
                          border: OutlineInputBorder(),
                          suffixText: 'دقيقة',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال وقت التنبيه';
                          }
                          final delay = int.tryParse(value);
                          if (delay == null || delay <= 0) {
                            return 'يرجى إدخال رقم صحيح أكبر من الصفر';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'عدد الدقائق التي بعدها يعطي التطبيق تنبيه عن تأخر الطالب عن الخروج',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveSettings,
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
                          'حفظ الإعدادات',
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
