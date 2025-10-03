import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/school.dart';
import '../models/student.dart';
import '../models/class_section.dart';
import '../models/staff.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إدارة المدارس
  static Future<String> createSchool(School school) async {
    try {
      final docRef = await _firestore.collection('schools').add(school.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('خطأ في إنشاء المدرسة: $e');
    }
  }

  static Future<List<School>> getSchools() async {
    try {
      final querySnapshot = await _firestore.collection('schools').get();
      return querySnapshot.docs
          .map((doc) => School.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب المدارس: $e');
    }
  }

  static Future<void> updateSchool(String schoolId, School school) async {
    try {
      await _firestore.collection('schools').doc(schoolId).update(school.toMap());
    } catch (e) {
      throw Exception('خطأ في تحديث المدرسة: $e');
    }
  }

  // تحديث إعدادات المدرسة (النطاق ووقت التنبيه)
  static Future<void> updateSchoolSettings(String schoolId, double range, int delayMinutes) async {
    try {
      await _firestore.collection('schools').doc(schoolId).update({
        'range': range,
        'delayMinutes': delayMinutes,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('خطأ في تحديث إعدادات المدرسة: $e');
    }
  }

  // الحصول على مدرسة واحدة
  static Future<School?> getSchool(String schoolId) async {
    try {
      final doc = await _firestore.collection('schools').doc(schoolId).get();
      if (doc.exists) {
        return School.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في جلب المدرسة: $e');
    }
  }

  static Future<void> deleteSchool(String schoolId) async {
    try {
      await _firestore.collection('schools').doc(schoolId).delete();
    } catch (e) {
      throw Exception('خطأ في حذف المدرسة: $e');
    }
  }

  // إدارة الفصول
  static Future<String> createClassSection(ClassSection classSection) async {
    try {
      final docRef = await _firestore
          .collection('class_sections')
          .add(classSection.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('خطأ في إنشاء الفصل: $e');
    }
  }

  static Future<List<ClassSection>> getClassSections(String schoolId) async {
    try {
      final querySnapshot = await _firestore
          .collection('class_sections')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      return querySnapshot.docs
          .map((doc) => ClassSection.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب الفصول: $e');
    }
  }

  static Future<void> updateClassSection(String classSectionId, ClassSection classSection) async {
    try {
      await _firestore.collection('class_sections').doc(classSectionId).update(classSection.toMap());
    } catch (e) {
      throw Exception('خطأ في تحديث الفصل: $e');
    }
  }

  static Future<void> deleteClassSection(String classSectionId) async {
    try {
      await _firestore.collection('class_sections').doc(classSectionId).delete();
    } catch (e) {
      throw Exception('خطأ في حذف الفصل: $e');
    }
  }

  // إدارة الطلاب
  static Future<String> createStudent(Student student) async {
    try {
      final docRef = await _firestore.collection('students').add(student.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('خطأ في إنشاء الطالب: $e');
    }
  }

  static Future<List<Student>> getStudents(String schoolId) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      return querySnapshot.docs
          .map((doc) => Student.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب الطلاب: $e');
    }
  }

  static Future<void> updateStudent(String studentId, Student student) async {
    try {
      await _firestore.collection('students').doc(studentId).update(student.toMap());
    } catch (e) {
      throw Exception('خطأ في تحديث الطالب: $e');
    }
  }

  static Future<void> deleteStudent(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).delete();
    } catch (e) {
      throw Exception('خطأ في حذف الطالب: $e');
    }
  }

  // إدارة المنسوبين
  static Future<String> createStaff(Staff staff) async {
    try {
      final docRef = await _firestore.collection('staff').add(staff.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('خطأ في إنشاء المنسوب: $e');
    }
  }

  static Future<List<Staff>> getStaff(String schoolId) async {
    try {
      final querySnapshot = await _firestore
          .collection('staff')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      return querySnapshot.docs
          .map((doc) => Staff.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب المنسوبين: $e');
    }
  }

  static Future<void> updateStaff(String staffId, Staff staff) async {
    try {
      await _firestore.collection('staff').doc(staffId).update(staff.toMap());
    } catch (e) {
      throw Exception('خطأ في تحديث المنسوب: $e');
    }
  }

  static Future<void> deleteStaff(String staffId) async {
    try {
      await _firestore.collection('staff').doc(staffId).delete();
    } catch (e) {
      throw Exception('خطأ في حذف المنسوب: $e');
    }
  }

  // رفع ملف Excel للطلاب مع إنشاء الفصول تلقائياً
  static Future<void> uploadStudentsFromExcel(
      String schoolId, List<Map<String, dynamic>> studentsData) async {
    try {
      // استخراج الفصول الفريدة من بيانات الطلاب
      final uniqueClassSections = _extractUniqueClassSections(studentsData);
      
      // الحصول على الفصول الموجودة حالياً
      final existingClassSections = await getClassSections(schoolId);
      final existingClassNames = existingClassSections.map((c) => c.name).toSet();
      
      // إنشاء الفصول الجديدة
      final newClassSections = uniqueClassSections
          .where((className) => !existingClassNames.contains(className))
          .toList();
      
      final batch = _firestore.batch();
      
      // إضافة الفصول الجديدة
      for (String className in newClassSections) {
        final classSection = ClassSection(
          id: '',
          schoolId: schoolId,
          name: className,
          description: 'تم إنشاؤه تلقائياً من ملف Excel',
          createdAt: DateTime.now(),
        );
        
        final classDocRef = _firestore.collection('class_sections').doc();
        batch.set(classDocRef, classSection.toMap());
      }
      
      // إضافة الطلاب
      for (var studentData in studentsData) {
        final student = Student(
          id: '',
          schoolId: schoolId,
          idNumber: studentData['idNumber'] ?? '',
          name: studentData['name'] ?? '',
          classSection: studentData['classSection'] ?? '',
          guardianName: studentData['guardianName'] ?? '',
          guardianPhone: studentData['guardianPhone'] ?? '',
          createdAt: DateTime.now(),
        );
        
        final docRef = _firestore.collection('students').doc();
        batch.set(docRef, student.toMap());
      }
      
      await batch.commit();
      
      String message = 'تم رفع ${studentsData.length} طالب بنجاح';
      if (newClassSections.isNotEmpty) {
        message += ' وتم إنشاء ${newClassSections.length} فصل جديد';
      }
      print(message);
    } catch (e) {
      print('خطأ في رفع بيانات الطلاب: $e');
      throw Exception('خطأ في رفع بيانات الطلاب: $e');
    }
  }

  // استخراج الفصول الفريدة من بيانات الطلاب
  static List<String> _extractUniqueClassSections(List<Map<String, dynamic>> studentsData) {
    Set<String> uniqueClassSections = {};
    
    for (var student in studentsData) {
      String classSection = student['classSection']?.toString().trim() ?? '';
      if (classSection.isNotEmpty) {
        uniqueClassSections.add(classSection);
      }
    }
    
    return uniqueClassSections.toList();
  }

  // إحصائيات المدرسة
  static Future<Map<String, int>> getSchoolStats(String schoolId) async {
    try {
      final studentsSnapshot = await _firestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      
      final classesSnapshot = await _firestore
          .collection('class_sections')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      
      final staffSnapshot = await _firestore
          .collection('staff')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      
      return {
        'students': studentsSnapshot.docs.length,
        'classes': classesSnapshot.docs.length,
        'staff': staffSnapshot.docs.length,
      };
    } catch (e) {
      throw Exception('خطأ في جلب إحصائيات المدرسة: $e');
    }
  }
}
