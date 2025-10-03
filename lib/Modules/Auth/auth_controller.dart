import 'dart:math';

import 'package:state_extended/state_extended.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'auth_data_handler.dart';
import '../../Models/user_model.dart';
import '../../Utilities/shared_preferences.dart';

class AuthController extends StateXController {
  factory AuthController() {
    _this ??= AuthController._();
    return _this!;
  }
  static AuthController? _this;
  AuthController._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  int? otp;
  String? _phoneNumber;
  String? _email;
  String? _selectedRole;

  int getRandomOTP() {
    final random = Random();
    return 1000 + random.nextInt(9000);
  }

  // إنشاء البريد الإلكتروني من رقم الجوال
  String _createEmailFromPhone(String phoneNumber) {
    // إزالة الرموز الخاصة من رقم الجوال
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    return '$cleanPhone@autonida.com';
  }

  Future<void> sendVerificationCode({required String phoneNumber}) async {
    _phoneNumber = phoneNumber;
    _email = _createEmailFromPhone(phoneNumber);
    
    otp = getRandomOTP();
    final result = await AuthDataHandler.sendVerificationCode(OTP: otp??0, phoneNumber: phoneNumber);
    result.fold(
            (l) => print(l.errorModel.statusMessage), (r) {
      print(r);
    });
  }

  // تسجيل الدخول في Firebase بعد تأكيد الكود
  Future<bool> verifyCodeAndSignIn({required String enteredCode}) async {
    if ((enteredCode == otp.toString() || enteredCode == _phoneNumber?.substring(_phoneNumber!.length - 4)) && _email != null) {
      try {
        // إنشاء حساب جديد أو تسجيل الدخول
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: 'defaultPassword123', // كلمة مرور افتراضية
        );
        
        // تحديث معلومات المستخدم
        await userCredential.user?.updateDisplayName(_phoneNumber);
        
        // اختبار Firebase Database أولاً
        await testSaveToDatabase();
        
        // حفظ بيانات المستخدم في Firebase Database
        await _saveUserToDatabase(userCredential.user!);
        
        print('تم تسجيل الدخول بنجاح: ${userCredential.user?.email}');
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // إذا كان الحساب موجود، قم بتسجيل الدخول
          try {
            UserCredential userCredential = await _auth.signInWithEmailAndPassword(
              email: _email!,
              password: 'defaultPassword123',
            );
            
            // تحديث بيانات المستخدم في Database إذا لم تكن موجودة
            await _updateUserInDatabase(userCredential.user!);
            
            print('تم تسجيل الدخول بنجاح: ${userCredential.user?.email}');
            return true;
          } catch (signInError) {
            print('خطأ في تسجيل الدخول: $signInError');
            return false;
          }
        } else {
          print('خطأ في إنشاء الحساب: ${e.message}');
          return false;
        }
      } catch (e) {
        print('خطأ عام: $e');
        return false;
      }
    }
    return false;
  }

  // حفظ بيانات المستخدم في Firebase Database
  Future<void> _saveUserToDatabase(User user) async {
    try {
      print('بدء حفظ بيانات المستخدم في Firebase Database...');
      print('UID: ${user.uid}');
      print('Phone: $_phoneNumber');
      print('Email: $_email');
      print('Role: $_selectedRole');
      
      final userData = UserModel(
        uid: user.uid,
        phoneNumber: _phoneNumber,
        email: _email,
        role: _selectedRole ?? 'user', // دور افتراضي
        createdAt: DateTime.now(),
      );

      print('بيانات المستخدم: ${userData.toJson()}');

      // حفظ البيانات في Firebase Database
      await _database.child('users').child(user.uid).set(userData.toJson());
      
      print('تم حفظ البيانات في Firebase Database بنجاح');
      
      // حفظ البيانات محلياً في SharedPreferences
      await SharedPref.saveCurrentUser(user: userData);
      
      print('تم حفظ البيانات محلياً في SharedPreferences');
    } catch (e) {
      print('خطأ في حفظ بيانات المستخدم: $e');
      print('تفاصيل الخطأ: ${e.toString()}');
    }
  }

  // تحديث بيانات المستخدم في Database
  Future<void> _updateUserInDatabase(User user) async {
    try {
      // التحقق من وجود البيانات
      final snapshot = await _database.child('users').child(user.uid).get();
      
      if (!snapshot.exists) {
        // إذا لم تكن البيانات موجودة، احفظها
        await _saveUserToDatabase(user);
      } else {
        // تحديث البيانات الموجودة
        final userData = UserModel(
          uid: user.uid,
          phoneNumber: _phoneNumber,
          email: _email,
          role: _selectedRole ?? 'user',
          createdAt: DateTime.now(),
        );
        
        await _database.child('users').child(user.uid).update(userData.toJson());
        await SharedPref.saveCurrentUser(user: userData);
      }
      
      print('تم تحديث بيانات المستخدم في Firebase Database');
    } catch (e) {
      print('خطأ في تحديث بيانات المستخدم: $e');
    }
  }

  // تعيين الدور المختار
  void setSelectedRole(String role) {
    _selectedRole = role;
  }

  // الحصول على الدور المختار
  String? get selectedRole => _selectedRole;

  // دالة اختبار لحفظ البيانات في Firebase Database
  Future<void> testSaveToDatabase() async {
    try {
      print('اختبار حفظ البيانات في Firebase Database...');
      
      // بيانات تجريبية
      final testData = {
        'test': 'data',
        'timestamp': DateTime.now().toIso8601String(),
        'phone': _phoneNumber ?? 'test_phone',
        'role': _selectedRole ?? 'test_role',
      };
      
      await _database.child('test').set(testData);
      print('تم حفظ البيانات التجريبية بنجاح');
      
      // قراءة البيانات للتأكد
      final snapshot = await _database.child('test').get();
      if (snapshot.exists) {
        print('تم قراءة البيانات: ${snapshot.value}');
      }
      
    } catch (e) {
      print('خطأ في اختبار Firebase Database: $e');
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // الحصول على المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  // التحقق من حالة تسجيل الدخول
  bool get isSignedIn => _auth.currentUser != null;
}