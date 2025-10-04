import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataHandler {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save new user data to Firestore
  static Future<bool> saveNewUser({
    required String phoneNumber,
    String? name,
    String? email,
    String? profileImage,
    String? homeLocation,
    String? language = 'ar',
    String? role = 'guardian',
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No authenticated user found');
        return false;
      }

      // Create user data map
      Map<String, dynamic> userData = {
        'uid': currentUser.uid,
        'phoneNumber': phoneNumber,
        'name': name ?? 'User',
        'email': email ?? '',
        'profileImage': profileImage ?? '',
        'homeLocation': homeLocation ?? '',
        'language': language,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      };

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(userData, SetOptions(merge: true));

      print('User data saved successfully to Firestore');
      return true;
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      return false;
    }
  }

  /// Get user data from Firestore
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      } else {
        print('User document not found');
        return null;
      }
    } catch (e) {
      print('Error getting user data from Firestore: $e');
      return null;
    }
  }

  /// Update user data in Firestore
  static Future<bool> updateUserData({
    required String uid,
    String? name,
    String? email,
    String? profileImage,
    String? homeLocation,
    String? language,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (profileImage != null) updateData['profileImage'] = profileImage;
      if (homeLocation != null) updateData['homeLocation'] = homeLocation;
      if (language != null) updateData['language'] = language;

      await _firestore
          .collection('users')
          .doc(uid)
          .update(updateData);

      print('User data updated successfully in Firestore');
      return true;
    } catch (e) {
      print('Error updating user data in Firestore: $e');
      return false;
    }
  }

  /// Delete user data from Firestore
  static Future<bool> deleteUserData(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .delete();

      print('User data deleted successfully from Firestore');
      return true;
    } catch (e) {
      print('Error deleting user data from Firestore: $e');
      return false;
    }
  }

  /// Check if user exists in Firestore
  static Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  /// Get all users (for admin purposes)
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> users = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        users.add(data);
      }

      return users;
    } catch (e) {
      print('Error getting all users from Firestore: $e');
      return [];
    }
  }

  /// Get users by role
  static Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role)
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> users = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        users.add(data);
      }

      return users;
    } catch (e) {
      print('Error getting users by role from Firestore: $e');
      return [];
    }
  }

  /// Update user language preference
  static Future<bool> updateUserLanguage(String uid, String language) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'language': language,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('User language updated successfully');
      return true;
    } catch (e) {
      print('Error updating user language: $e');
      return false;
    }
  }

  /// Update user profile image
  static Future<bool> updateUserProfileImage(String uid, String imageUrl) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'profileImage': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('User profile image updated successfully');
      return true;
    } catch (e) {
      print('Error updating user profile image: $e');
      return false;
    }
  }

  /// Update user home location
  static Future<bool> updateUserHomeLocation(String uid, String location) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'homeLocation': location,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('User home location updated successfully');
      return true;
    } catch (e) {
      print('Error updating user home location: $e');
      return false;
    }
  }
}
