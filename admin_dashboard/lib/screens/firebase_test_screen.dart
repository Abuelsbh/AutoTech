import 'package:flutter/material.dart';
import '../services/firebase_test_service.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _testResults;
  String _log = '';

  void _addLog(String message) {
    setState(() {
      _log += '$message\n';
    });
    print(message);
  }

  Future<void> _runFullTest() async {
    setState(() {
      _isLoading = true;
      _log = '';
      _testResults = null;
    });

    _addLog('🚀 بدء الاختبار الشامل لـ Firebase...');

    try {
      // فحص الإعدادات
      _addLog('🔧 فحص إعدادات Firebase...');
      FirebaseTestService.testFirebaseConfig();

      // تشغيل الاختبار الشامل
      final results = await FirebaseTestService.runFullTest();
      
      setState(() {
        _testResults = results;
      });

      _addLog('📊 نتائج الاختبار:');
      _addLog('   الاتصال: ${results['connection'] ? '✅' : '❌'}');
      _addLog('   الكتابة: ${results['write'] ? '✅' : '❌'}');
      _addLog('   القراءة: ${results['read'] ? '✅' : '❌'}');
      _addLog('   النتيجة الإجمالية: ${results['overall'] ? '✅' : '❌'}');

      if (results['overall']) {
        _addLog('🎉 جميع الاختبارات نجحت! Firebase يعمل بشكل صحيح.');
      } else {
        _addLog('⚠️ بعض الاختبارات فشلت. تحقق من الإعدادات.');
      }

    } catch (e) {
      _addLog('❌ خطأ في الاختبار: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _log = '';
    });

    _addLog('🔍 اختبار الاتصال...');
    final result = await FirebaseTestService.testConnection();
    _addLog(result ? '✅ الاتصال يعمل' : '❌ الاتصال فشل');
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testWrite() async {
    setState(() {
      _isLoading = true;
      _log = '';
    });

    _addLog('🔍 اختبار الكتابة...');
    final result = await FirebaseTestService.testWrite();
    _addLog(result ? '✅ الكتابة تعمل' : '❌ الكتابة فشلت');
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testRead() async {
    setState(() {
      _isLoading = true;
      _log = '';
    });

    _addLog('🔍 اختبار القراءة...');
    final result = await FirebaseTestService.testRead();
    _addLog(result ? '✅ القراءة تعمل' : '❌ القراءة فشلت');
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _cleanup() async {
    setState(() {
      _isLoading = true;
    });

    await FirebaseTestService.cleanupTestData();
    _addLog('🧹 تم تنظيف بيانات الاختبار');
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار Firebase'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // أزرار الاختبار
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _runFullTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('اختبار شامل'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('اختبار الاتصال'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testWrite,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('اختبار الكتابة'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testRead,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('اختبار القراءة'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _cleanup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('تنظيف'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // مؤشر التحميل
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            // نتائج الاختبار
            if (_testResults != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'نتائج الاختبار:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _testResults!['connection'] ? Icons.check_circle : Icons.error,
                            color: _testResults!['connection'] ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text('الاتصال'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            _testResults!['write'] ? Icons.check_circle : Icons.error,
                            color: _testResults!['write'] ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text('الكتابة'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            _testResults!['read'] ? Icons.check_circle : Icons.error,
                            color: _testResults!['read'] ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text('القراءة'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Icon(
                            _testResults!['overall'] ? Icons.check_circle : Icons.error,
                            color: _testResults!['overall'] ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'النتيجة الإجمالية',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _testResults!['overall'] ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // سجل الأحداث
            const SizedBox(height: 16),
            const Text(
              'سجل الأحداث:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _log.isEmpty ? 'اضغط على أي زر لبدء الاختبار...' : _log,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
