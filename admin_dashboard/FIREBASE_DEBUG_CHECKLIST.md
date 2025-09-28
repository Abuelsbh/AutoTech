# قائمة فحص Firebase - تشخيص مشاكل رفع البيانات

## 🔍 خطوات التشخيص:

### 1. **فحص إعدادات Firebase Console:**

#### أ) تحقق من Firestore Database:
- [ ] هل تم إنشاء Firestore Database؟
- [ ] هل قاعدة البيانات في وضع "test mode"؟
- [ ] هل قواعد الأمان تسمح بالقراءة والكتابة؟

#### ب) تحقق من Authentication:
- [ ] هل تم تفعيل Email/Password authentication؟
- [ ] هل تم إنشاء مستخدمين تجريبيين؟

#### ج) تحقق من Project Settings:
- [ ] هل Project ID صحيح؟
- [ ] هل API Key صحيح؟
- [ ] هل App ID صحيح؟

### 2. **فحص ملف firebase_options.dart:**

#### أ) تحقق من القيم:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyB...', // يجب أن يبدأ بـ AIzaSy
  appId: '1:123456789:web:...', // يجب أن يحتوي على :web:
  messagingSenderId: '123456789', // يجب أن يكون رقم
  projectId: 'your-project-id', // يجب أن يكون Project ID الصحيح
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
);
```

#### ب) تحقق من التطابق:
- [ ] Project ID في firebase_options.dart = Project ID في Console
- [ ] API Key في firebase_options.dart = API Key في Console
- [ ] App ID في firebase_options.dart = App ID في Console

### 3. **فحص قواعد الأمان في Firestore:**

اذهب إلى Firestore Database > Rules وتأكد من:

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

### 4. **فحص Console للأخطاء:**

#### أ) أخطاء Firebase:
- [ ] هل تظهر أخطاء "permission denied"؟
- [ ] هل تظهر أخطاء "network error"؟
- [ ] هل تظهر أخطاء "invalid API key"؟

#### ب) أخطاء JavaScript:
- [ ] هل تظهر أخطاء في Console؟
- [ ] هل تظهر أخطاء "CORS"؟
- [ ] هل تظهر أخطاء "authentication"؟

### 5. **اختبار الاتصال:**

#### أ) اختبار بسيط:
1. افتح التطبيق
2. حاول إنشاء مدرسة جديدة
3. راقب Console للأخطاء
4. تحقق من Firebase Console

#### ب) اختبار Firestore مباشرة:
1. اذهب إلى Firebase Console
2. اذهب إلى Firestore Database
3. حاول إضافة document يدوياً
4. تأكد من أن العملية تعمل

## 🚨 الأخطاء الشائعة وحلولها:

### 1. **خطأ "Permission denied":**
```
الحل: تحقق من قواعد الأمان في Firestore
```

### 2. **خطأ "Invalid API key":**
```
الحل: تأكد من نسخ API key الصحيح من Firebase Console
```

### 3. **خطأ "Project not found":**
```
الحل: تأكد من Project ID الصحيح
```

### 4. **خطأ "Network error":**
```
الحل: تحقق من اتصال الإنترنت
```

### 5. **خطأ "CORS":**
```
الحل: تأكد من إعداد Firebase للويب بشكل صحيح
```

## 📋 معلومات مطلوبة للمساعدة:

### 1. **من Firebase Console:**
- Project ID
- API Key (يمكن إخفاء الجزء الأخير)
- App ID
- حالة Firestore Database
- قواعد الأمان الحالية

### 2. **من التطبيق:**
- رسائل الخطأ الكاملة
- لقطة شاشة من Console
- ما يحدث عند محاولة رفع البيانات

### 3. **من النظام:**
- نوع المتصفح
- رسائل الخطأ في Console
- حالة اتصال الإنترنت

## 🔧 خطوات الحل السريع:

### 1. **إعادة إعداد Firebase:**
```bash
# 1. امسح المشروع الحالي
# 2. أنشئ مشروع جديد
# 3. أعد إعداد Firestore
# 4. حدث firebase_options.dart
```

### 2. **اختبار الاتصال:**
```bash
# 1. شغل التطبيق
# 2. حاول إنشاء مدرسة
# 3. راقب Console
# 4. تحقق من Firebase
```

### 3. **إصلاح الأخطاء:**
```bash
# 1. صحح قواعد الأمان
# 2. صحح firebase_options.dart
# 3. أعد تشغيل التطبيق
# 4. اختبر مرة أخرى
```

---

**شاركني النتائج وسأساعدك في حل المشكلة! 🚀**
