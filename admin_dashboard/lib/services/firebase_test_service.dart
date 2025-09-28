import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // اختبار الاتصال بـ Firebase
  static Future<bool> testConnection() async {
    try {
      print('🔍 اختبار الاتصال بـ Firebase...');
      
      // محاولة قراءة من Firestore
      await _firestore.collection('test').limit(1).get();
      
      print('✅ الاتصال بـ Firebase يعمل بشكل صحيح');
      return true;
    } catch (e) {
      print('❌ خطأ في الاتصال بـ Firebase: $e');
      return false;
    }
  }

  // اختبار الكتابة في Firebase
  static Future<bool> testWrite() async {
    try {
      print('🔍 اختبار الكتابة في Firebase...');
      
      // محاولة كتابة test document
      await _firestore.collection('test').doc('connection_test').set({
        'timestamp': DateTime.now().toIso8601String(),
        'test': 'success',
        'message': 'Firebase connection is working',
      });
      
      print('✅ الكتابة في Firebase تعمل بشكل صحيح');
      return true;
    } catch (e) {
      print('❌ خطأ في الكتابة في Firebase: $e');
      return false;
    }
  }

  // اختبار القراءة من Firebase
  static Future<bool> testRead() async {
    try {
      print('🔍 اختبار القراءة من Firebase...');
      
      // محاولة قراءة test document
      final doc = await _firestore.collection('test').doc('connection_test').get();
      
      if (doc.exists) {
        print('✅ القراءة من Firebase تعمل بشكل صحيح');
        print('📄 البيانات: ${doc.data()}');
        return true;
      } else {
        print('⚠️ Document غير موجود، لكن القراءة تعمل');
        return true;
      }
    } catch (e) {
      print('❌ خطأ في القراءة من Firebase: $e');
      return false;
    }
  }

  // اختبار شامل لـ Firebase
  static Future<Map<String, dynamic>> runFullTest() async {
    print('🚀 بدء الاختبار الشامل لـ Firebase...');
    
    final results = {
      'connection': false,
      'write': false,
      'read': false,
      'overall': false,
    };

    // اختبار الاتصال
    results['connection'] = await testConnection();
    
    if (results['connection'] == true) {
      // اختبار الكتابة
      results['write'] = await testWrite();
      
      if (results['write'] == true) {
        // اختبار القراءة
        results['read'] = await testRead();
      }
    }

    // النتيجة الإجمالية
    results['overall'] = (results['connection'] == true) && (results['write'] == true) && (results['read'] == true);

    print('📊 نتائج الاختبار:');
    print('   الاتصال: ${(results['connection'] == true) ? '✅' : '❌'}');
    print('   الكتابة: ${(results['write'] == true) ? '✅' : '❌'}');
    print('   القراءة: ${(results['read'] == true) ? '✅' : '❌'}');
    print('   النتيجة الإجمالية: ${(results['overall'] == true) ? '✅' : '❌'}');

    return results;
  }

  // اختبار إعدادات Firebase
  static void testFirebaseConfig() {
    print('🔧 فحص إعدادات Firebase...');
    
    try {
      final app = FirebaseFirestore.instance.app;
      print('✅ Firebase App: ${app.name}');
      print('✅ Project ID: ${app.options.projectId}');
      final apiKey = app.options.apiKey;
      if (apiKey.isNotEmpty && apiKey.length > 10) {
        print('✅ API Key: ${apiKey.substring(0, 10)}...');
      } else {
        print('⚠️ API Key: غير متوفر أو قصير جداً');
      }
      print('✅ Auth Domain: ${app.options.authDomain}');
      print('✅ Storage Bucket: ${app.options.storageBucket}');
    } catch (e) {
      print('❌ خطأ في إعدادات Firebase: $e');
    }
  }

  // تنظيف بيانات الاختبار
  static Future<void> cleanupTestData() async {
    try {
      print('🧹 تنظيف بيانات الاختبار...');
      await _firestore.collection('test').doc('connection_test').delete();
      print('✅ تم تنظيف بيانات الاختبار');
    } catch (e) {
      print('⚠️ لا يمكن تنظيف بيانات الاختبار: $e');
    }
  }
}
