# إضافة دور المراقب - نظام إدارة المدارس

## 🎯 **التحديث المطبق:**

تم إضافة دور جديد للمراقب (Monitor) كدور منفصل عن الحارس (Guard) في نظام إدارة المنسوبين.

## 📊 **الأدوار المدعومة الآن:**

### 1. **👤 المعلم (Teacher)**
- **الرمز:** `StaffRole.teacher`
- **الاسم المعروض:** معلم
- **الأيقونة:** 👤 (Icons.person)
- **اللون:** أزرق (Colors.blue)

### 2. **⚙️ المدير (Principal)**
- **الرمز:** `StaffRole.principal`
- **الاسم المعروض:** مدير
- **الأيقونة:** ⚙️ (Icons.admin_panel_settings)
- **اللون:** أخضر (Colors.green)

### 3. **🛡️ الحارس (Guard)**
- **الرمز:** `StaffRole.guard`
- **الاسم المعروض:** حارس
- **الأيقونة:** 🛡️ (Icons.security)
- **اللون:** برتقالي (Colors.orange)

### 4. **👁️ المراقب (Monitor) - جديد**
- **الرمز:** `StaffRole.monitor`
- **الاسم المعروض:** مراقب
- **الأيقونة:** 👁️ (Icons.visibility)
- **اللون:** بنفسجي (Colors.purple)

## 🔧 **التغييرات المطبقة:**

### 1. **تحديث StaffRole enum:**
```dart
enum StaffRole {
  teacher,
  principal,
  guard,
  monitor, // جديد
}
```

### 2. **تحديث roleDisplayName:**
```dart
String get roleDisplayName {
  switch (role) {
    case StaffRole.teacher:
      return 'معلم';
    case StaffRole.principal:
      return 'مدير';
    case StaffRole.guard:
      return 'حارس';
    case StaffRole.monitor:
      return 'مراقب'; // جديد
  }
}
```

### 3. **تحديث الألوان:**
```dart
Color _getRoleColor(StaffRole role) {
  switch (role) {
    case StaffRole.teacher:
      return Colors.blue;
    case StaffRole.principal:
      return Colors.green;
    case StaffRole.guard:
      return Colors.orange;
    case StaffRole.monitor:
      return Colors.purple; // جديد
  }
}
```

### 4. **تحديث الأيقونات:**
```dart
IconData _getRoleIcon(StaffRole role) {
  switch (role) {
    case StaffRole.teacher:
      return Icons.person;
    case StaffRole.principal:
      return Icons.admin_panel_settings;
    case StaffRole.guard:
      return Icons.security;
    case StaffRole.monitor:
      return Icons.visibility; // جديد
  }
}
```

### 5. **إضافة فلتر للمراقب:**
```dart
FilterChip(
  label: const Text('مراقب'),
  selected: _selectedRole == StaffRole.monitor,
  onSelected: (selected) {
    setState(() {
      _selectedRole = selected ? StaffRole.monitor : null;
    });
  },
),
```

## 🎨 **المميزات الجديدة:**

### ✅ **في صفحة إدارة المنسوبين:**
- ✅ فلتر "مراقب" لعرض المراقبين فقط
- ✅ أيقونة 👁️ (Icons.visibility) للمراقبين
- ✅ لون بنفسجي مميز للمراقبين
- ✅ عرض "مراقب" تحت اسم المنسوب

### ✅ **في صفحة إضافة منسوب:**
- ✅ خيار "مراقب" في القائمة المنسدلة
- ✅ اسم العرض "مراقب" باللغة العربية
- ✅ حفظ تلقائي في Firebase

### ✅ **في قائمة المنسوبين:**
- ✅ عرض المراقبين بأيقونة ولون مميزين
- ✅ فلترة منفصلة للمراقبين
- ✅ بحث وعرض سهل

## 🔍 **الفرق بين الحارس والمراقب:**

### **🛡️ الحارس (Guard):**
- **الوظيفة:** حماية المدرسة والأمن
- **الأيقونة:** 🛡️ (Icons.security)
- **اللون:** برتقالي
- **المسؤولية:** الأمن والحماية

### **👁️ المراقب (Monitor):**
- **الوظيفة:** مراقبة الطلاب والأنشطة
- **الأيقونة:** 👁️ (Icons.visibility)
- **اللون:** بنفسجي
- **المسؤولية:** المراقبة والإشراف

## 🚀 **كيفية الاستخدام:**

### **إضافة مراقب جديد:**
1. اذهب إلى "إدارة المنسوبين"
2. اضغط "+" لإضافة منسوب جديد
3. ملء البيانات:
   - **الاسم:** اسم المراقب
   - **البريد الإلكتروني:** بريد المراقب
   - **رقم الهاتف:** رقم هاتف المراقب
   - **اسم المستخدم:** اسم المستخدم
   - **كلمة المرور:** كلمة المرور
   - **الدور:** اختر "مراقب" من القائمة
4. اضغط "إضافة المنسوب"

### **فلترة المراقبين:**
1. في صفحة إدارة المنسوبين
2. اضغط على فلتر "مراقب"
3. سيتم عرض المراقبين فقط

## 📱 **واجهة المستخدم:**

### **الفلاتر المتاحة:**
- **الكل:** عرض جميع المنسوبين
- **معلم:** عرض المعلمين فقط
- **مدير:** عرض المديرين فقط
- **حارس:** عرض الحرس فقط
- **مراقب:** عرض المراقبين فقط (جديد)

### **الألوان والأيقونات:**
- **معلم:** أزرق + 👤
- **مدير:** أخضر + ⚙️
- **حارس:** برتقالي + 🛡️
- **مراقب:** بنفسجي + 👁️

## 🎯 **النتيجة:**

### ✅ **تم إضافة دور المراقب:**
- ✅ دور جديد في النظام
- ✅ أيقونة ولون مميزان
- ✅ فلترة منفصلة
- ✅ عرض واضح في الواجهة

### ✅ **النظام محسن:**
- ✅ دعم 4 أدوار مختلفة
- ✅ تمييز بصري واضح
- ✅ سهولة في الإدارة
- ✅ مرونة في التصنيف

---

**🎉 تم إضافة دور المراقب بنجاح!**

**يمكنك الآن إضافة المراقبين كدور منفصل عن الحرس! 🚀**
