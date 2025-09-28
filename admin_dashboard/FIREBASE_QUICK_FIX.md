# حل سريع لمشكلة Firebase - "client is offline"

## 🚨 المشكلة:
```
خطأ في تحميل إعدادات المدرسة: Exception : خطأ في جلب المدرسة: 
[cloud_firestore/unavailable] Failed to get document because the client is offline.
```

## 🔧 الحل السريع:

### 1. إعداد Firebase Console (مطلوب)

#### أ) إنشاء مشروع Firebase:
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. اضغط "Create a project"
3. أدخل اسم المشروع: `school-management-system`
4. فعّل Google Analytics (اختياري)
5. اضغط "Create project"

#### ب) إضافة تطبيق ويب:
1. في لوحة التحكم، اضغط على أيقونة الويب `</>`
2. أدخل اسم التطبيق: `admin-dashboard`
3. اضغط "Register app"
4. **انسخ كود التكوين** (ستحتاجه لاحقاً)

#### ج) إعداد Firestore Database:
1. في القائمة الجانبية، اضغط "Firestore Database"
2. اضغط "Create database"
3. اختر "Start in test mode" (للاختبار)
4. اختر موقع قاعدة البيانات
5. اضغط "Done"

#### د) إعداد Authentication:
1. في القائمة الجانبية، اضغط "Authentication"
2. اضغط "Get started"
3. اذهب إلى تبويب "Sign-in method"
4. فعّل "Email/Password"
5. اضغط "Save"

### 2. تحديث ملف firebase_options.dart

استبدل محتوى `lib/firebase_options.dart` بالكود الذي حصلت عليه من Firebase Console:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', // ضع مفتاح API هنا
  appId: '1:123456789:web:abcdef123456789', // ضع App ID هنا
  messagingSenderId: '123456789', // ضع Sender ID هنا
  projectId: 'your-project-id', // ضع Project ID هنا
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
);
```

### 3. إعداد قواعد الأمان في Firestore

اذهب إلى Firestore Database > Rules واستبدل القواعد بـ:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**⚠️ تحذير:** هذه القواعد للاختبار فقط!

### 4. إعادة تشغيل التطبيق

```bash
cd admin_dashboard
flutter clean
flutter pub get
flutter run -d chrome
```

## 🧪 اختبار النظام:

### 1. إنشاء مدرسة تجريبية:
1. سجل دخول كمسؤول شركة (`admin` / `admin123`)
2. اضغط "+" لإضافة مدرسة جديدة
3. املأ البيانات:
   - اسم المدرسة: "مدرسة التجربة"
   - الموقع: "الرياض"
   - اسم المستخدم: `school_test`
   - كلمة المرور: `test123`
4. اضغط "إنشاء المدرسة"

### 2. اختبار إعدادات المدرسة:
1. سجل دخول كمسؤول مدرسة (`school_test` / `test123`)
2. اذهب إلى "الإعدادات"
3. يجب أن تعمل الآن بدون أخطاء
4. جرب تغيير القيم وحفظها

## 🔍 التحقق من الإعداد:

### 1. في Firebase Console:
- اذهب إلى Firestore Database
- يجب أن ترى مجموعة `schools` مع بيانات المدرسة
- يجب أن ترى مجموعة `class_sections` فارغة
- يجب أن ترى مجموعة `students` فارغة
- يجب أن ترى مجموعة `staff` فارغة

### 2. في التطبيق:
- يجب أن تعمل جميع الشاشات بدون أخطاء
- يجب أن تظهر الإحصائيات (0 للبيانات الجديدة)
- يجب أن تعمل عمليات الإضافة والحذف

## 🚨 إذا استمر الخطأ:

### 1. تحقق من اتصال الإنترنت
### 2. تأكد من تحديث firebase_options.dart
### 3. تأكد من إعداد Firestore Database
### 4. تأكد من قواعد الأمان
### 5. جرب إعادة تشغيل التطبيق

## 📞 الدعم:

إذا استمرت المشكلة:
1. تحقق من رسائل الخطأ في Console
2. تأكد من إعداد Firebase Console
3. راجع ملف `FIREBASE_SETUP.md` للتفاصيل الكاملة

---

**بعد إكمال هذه الخطوات، سيعمل النظام بشكل مثالي مع Firebase! 🚀**
