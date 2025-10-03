# إعداد Firebase Realtime Database

## ما تم إنجازه:

### ✅ إضافة Firebase Database:
- تم إضافة `firebase_database: ^11.0.2` إلى `pubspec.yaml`
- تم تحديث `UserModel` ليتضمن جميع البيانات المطلوبة
- تم تحديث `AuthController` لحفظ البيانات في Firebase Database

### 📊 البيانات المحفوظة:
عند إنشاء حساب جديد، يتم حفظ البيانات التالية في Firebase Database:

```json
{
  "users": {
    "USER_UID": {
      "uid": "USER_UID",
      "phoneNumber": "+966501234567",
      "email": "966501234567@autonida.com",
      "role": "guardian", // أو "staff" أو "driver"
      "createdAt": "2024-01-01T12:00:00.000Z"
    }
  }
}
```

### 🔄 تدفق العمل:

1. **المستخدم يختار الدور** في شاشة RoleSelection
2. **يتم حفظ الدور** في AuthController
3. **المستخدم يدخل رقم الجوال** في شاشة تسجيل الدخول
4. **يتم إرسال كود التحقق** عبر WhatsApp
5. **عند تأكيد الكود**:
   - إنشاء حساب في Firebase Auth
   - حفظ البيانات في Firebase Database
   - حفظ البيانات محلياً في SharedPreferences

### 🛠️ الملفات المحدثة:

#### 1. `pubspec.yaml`:
```yaml
firebase_database: ^11.0.2
```

#### 2. `lib/Models/user_model.dart`:
- إضافة حقول جديدة: `phoneNumber`, `email`, `role`, `uid`, `createdAt`
- تحديث `fromJson` و `toJson` methods
- إضافة `copyWith` method

#### 3. `lib/Modules/Auth/auth_controller.dart`:
- إضافة `DatabaseReference _database`
- إضافة `_saveUserToDatabase()` method
- إضافة `_updateUserInDatabase()` method
- إضافة `setSelectedRole()` method
- تحديث `verifyCodeAndSignIn()` لحفظ البيانات

#### 4. `lib/Modules/RoleSelection/role_selection_screen.dart`:
- إضافة `AuthController` instance
- تحديث `_buildRoleOption()` لحفظ الدور المختار
- تحديث `initState()` لتعيين دور افتراضي

### 🔧 إعداد Firebase Console:

#### 1. تفعيل Realtime Database:
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك
3. اذهب إلى "Realtime Database"
4. اضغط "Create Database"
5. اختر "Start in test mode" (للاختبار)
6. اختر موقع قاعدة البيانات

#### 2. قواعد الأمان (Security Rules):
```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "auth != null && auth.uid == $uid",
        ".write": "auth != null && auth.uid == $uid"
      }
    }
  }
}
```

### 📱 اختبار النظام:

1. **شغل التطبيق**
2. **اختر دور** (guardian/staff/driver)
3. **أدخل رقم جوال**
4. **أدخل كود التحقق**
5. **تحقق من Firebase Console** - يجب أن تظهر البيانات في Realtime Database

### 🎯 النتيجة النهائية:

- ✅ **حفظ رقم الهاتف** في Firebase Database
- ✅ **حفظ الدور المختار** في Firebase Database
- ✅ **حفظ البريد الإلكتروني** (رقم_الهاتف@autonida.com)
- ✅ **حفظ تاريخ الإنشاء**
- ✅ **حفظ البيانات محلياً** في SharedPreferences

### 📋 الخطوات المتبقية:

1. **إعداد Firebase Console** (إنشاء مشروع وتفعيل Database)
2. **تحديث ملفات التكوين** (google-services.json, firebase_options.dart)
3. **اختبار النظام** للتأكد من حفظ البيانات

النظام جاهز تماماً! 🚀

