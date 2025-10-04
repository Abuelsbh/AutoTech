import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fast_http/core/Error/failures.dart';
import '../../Models/student_model.dart';

class HomeDataHandler {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Either<Failure, List<StudentModel>>> getStudentsByGuardianPhone({
    required String guardianPhone,
  }) async {
    try {
      // Query students collection where guardianPhone matches
      final QuerySnapshot querySnapshot = await _firestore
          .collection('students')
          .where('guardianPhone', isEqualTo: guardianPhone)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return const Right([]);
      }

      // Convert documents to StudentModel objects
      List<StudentModel> students = [];
      
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> studentData = doc.data() as Map<String, dynamic>;
        studentData['id'] = doc.id; // Add document ID
        
        // Get school name if schoolId is available
        if (studentData['schoolId'] != null) {
          try {
            final schoolDoc = await _firestore
                .collection('schools')
                .doc(studentData['schoolId'])
                .get();
            
            if (schoolDoc.exists) {
              Map<String, dynamic> schoolData = schoolDoc.data() as Map<String, dynamic>;
              studentData['schoolName'] = schoolData['name'] ?? '';
              studentData['imageSchool'] = schoolData['logo'] ?? '';
            }
          } catch (e) {
            print('Error fetching school name: $e');
            studentData['schoolName'] = '';
          }
        }
        
        students.add(StudentModel.fromMap(studentData));
      }

      return Right(students);
    } catch (e) {
      // Return empty list on error instead of throwing exception
      print('Error fetching students: $e');
      return const Right([]);
    }
  }

  /// Get all students (for general listing)
  /// Returns a list of all students in the database
  static Future<Either<Failure, List<StudentModel>>> getAllStudents() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('students')
          .get();

      if (querySnapshot.docs.isEmpty) {
        return const Right([]);
      }

      // Convert documents to StudentModel objects
      List<StudentModel> students = [];
      
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> studentData = doc.data() as Map<String, dynamic>;
        studentData['id'] = doc.id; // Add document ID
        
        // Get school name if schoolId is available
        if (studentData['schoolId'] != null) {
          try {
            final schoolDoc = await _firestore
                .collection('schools')
                .doc(studentData['schoolId'])
                .get();
            
            if (schoolDoc.exists) {
              Map<String, dynamic> schoolData = schoolDoc.data() as Map<String, dynamic>;
              studentData['schoolName'] = schoolData['name'] ?? '';
              studentData['imageSchool'] = schoolData['logo'] ?? '';
            }
          } catch (e) {
            print('Error fetching school name: $e');
            studentData['schoolName'] = '';
          }
        }
        
        students.add(StudentModel.fromMap(studentData));
      }

      return Right(students);
    } catch (e) {
      // Return empty list on error instead of throwing exception
      print('Error fetching all students: $e');
      return const Right([]);
    }
  }

  /// Get students by school ID
  /// Returns a list of students belonging to a specific school
  static Future<Either<Failure, List<StudentModel>>> getStudentsBySchoolId({
    required String schoolId,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return const Right([]);
      }

      // Convert documents to StudentModel objects
      List<StudentModel> students = [];
      
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> studentData = doc.data() as Map<String, dynamic>;
        studentData['id'] = doc.id; // Add document ID
        
        // Get school name
        try {
          final schoolDoc = await _firestore
              .collection('schools')
              .doc(schoolId)
              .get();
          
          if (schoolDoc.exists) {
            Map<String, dynamic> schoolData = schoolDoc.data() as Map<String, dynamic>;
            studentData['schoolName'] = schoolData['name'] ?? '';
            studentData['imageSchool'] = schoolData['logo'] ?? '';
          }
        } catch (e) {
          print('Error fetching school name: $e');
          studentData['schoolName'] = '';
        }
        
        students.add(StudentModel.fromMap(studentData));
      }

      return Right(students);
    } catch (e) {
      // Return empty list on error instead of throwing exception
      print('Error fetching students by school: $e');
      return const Right([]);
    }
  }

  /// Update student photo in Firebase
  /// Updates the imageProfile field for a specific student
  static Future<bool> updateStudentPhoto({
    required String studentId,
    required String base64Image,
  }) async {
    try {
      await _firestore
          .collection('students')
          .doc(studentId)
          .update({
        'imageProfile': base64Image,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error updating student photo: $e');
      return false;
    }
  }
}
