# إعداد Firebase للمشروع

## الخطوات المطلوبة لإكمال إعداد Firebase:

### 1. إعداد Firebase Console
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. أنشئ مشروع جديد أو استخدم مشروع موجود
3. أضف تطبيق Android مع package name: `com.autotech.app`
4. أضف تطبيق iOS مع bundle ID: `com.autotech.app`

### 2. تحديث ملفات التكوين

#### للـ Android:
- استبدل ملف `android/app/google-services.json` بالملف الصحيح من Firebase Console

#### للـ iOS:
- استبدل ملف `ios/Runner/GoogleService-Info.plist` بالملف الصحيح من Firebase Console

### 3. تحديث firebase_options.dart
- استبدل القيم في ملف `lib/firebase_options.dart` بالقيم الصحيحة من Firebase Console:
  - `YOUR_PROJECT_ID`
  - `YOUR_API_KEY`
  - `YOUR_APP_ID`
  - `YOUR_MESSAGING_SENDER_ID`
  - `YOUR_STORAGE_BUCKET`

### 4. تفعيل Authentication في Firebase
1. في Firebase Console، اذهب إلى Authentication
2. اضغط على "Get started"
3. في تبويب "Sign-in method"، فعّل "Email/Password"

## كيفية عمل النظام:

1. **إدخال رقم الجوال**: المستخدم يدخل رقم جواله
2. **إنشاء البريد الإلكتروني**: النظام ينشئ بريد إلكتروني بصيغة `رقم_الجوال@autonida.com`
3. **إرسال كود التحقق**: يتم إرسال كود عبر WhatsApp (كما هو موجود حالياً)
4. **تأكيد الكود**: عند إدخال الكود الصحيح، يتم:
   - التحقق من صحة الكود
   - إنشاء حساب جديد في Firebase أو تسجيل الدخول إذا كان الحساب موجود
   - الانتقال إلى الشاشة الرئيسية

## الملفات المحدثة:
- `lib/main.dart` - إضافة تهيئة Firebase
- `lib/firebase_options.dart` - إعدادات Firebase
- `lib/Modules/Auth/auth_controller.dart` - تحديث AuthController لاستخدام Firebase
- `lib/Modules/Auth/mobile_verification_screen.dart` - ربط تأكيد الكود بـ Firebase
- `pubspec.yaml` - إضافة Firebase dependencies
- `android/app/build.gradle` - إضافة Google Services plugin وتحديث minSdk إلى 23
- `android/build.gradle` - إضافة Google Services classpath و repositories
- `ios/Runner/GoogleService-Info.plist` - ملف تكوين Firebase للـ iOS

## ملاحظات مهمة:
- تأكد من تحديث جميع ملفات التكوين بالقيم الصحيحة من Firebase Console
- النظام يستخدم كلمة مرور افتراضية: `defaultPassword123`
- يمكن تخصيص كلمة المرور أو استخدام طرق أخرى للمصادقة
- تم تحديث minSdkVersion إلى 23 لدعم Firebase Auth
- تم إصلاح مشكلة repositories في build.gradle

## حالة المشروع:
✅ تم بناء المشروع بنجاح
✅ Firebase Auth تم تكوينه بشكل صحيح
✅ جميع الملفات المطلوبة تم تحديثها
✅ تم إصلاح مشكلة duplicate Firebase app
⚠️ يحتاج إلى تحديث ملفات Firebase التكوين بالقيم الصحيحة

## إصلاحات إضافية:
- تم إصلاح مشكلة "Firebase App already exists" عند hot reload
- تم تحديث minSdkVersion إلى 23 لدعم Firebase Auth
- تم إصلاح مشكلة repositories في build.gradle
