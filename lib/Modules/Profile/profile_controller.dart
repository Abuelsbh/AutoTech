import 'package:auto_tech/Modules/LanguageSelection/language_selection_screen.dart';
import 'package:auto_tech/Utilities/shared_preferences.dart';
import 'package:auto_tech/Widgets/language_selection_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import '../../Utilities/router_config.dart';
import 'user_data_handler.dart';

class ProfileController extends StateXController {
  // singleton
  factory ProfileController() => _this ??= ProfileController._();
  static ProfileController? _this;
  ProfileController._();

  /// Loading state indicator for UI feedback during operations
  bool loading = false;

  /// User data
  String? userName;
  String? userPhone;
  String? userEmail;
  String? userProfileImage;
  String? userHomeLocation;
  String? userLanguage;
  String? userRole;
  String? userId;

  /// Initialize user data from Firebase Auth and Firestore
  Future<void> initUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
        userName = user.displayName ?? 'Ali Mohammed';
        userEmail = user.email ?? '';
        userPhone = user.phoneNumber ?? '+966 0501234567';
      });

      // Load additional data from Firestore
      await _loadUserDataFromFirestore(user.uid);
    }
  }

  /// Load user data from Firestore
  Future<void> _loadUserDataFromFirestore(String uid) async {
    try {
      Map<String, dynamic>? userData = await UserDataHandler.getUserData(uid);
      if (userData != null) {
        setState(() {
          userName = userData['name'] ?? userName;
          userEmail = userData['email'] ?? userEmail;
          userPhone = userData['phoneNumber'] ?? userPhone;
          userProfileImage = userData['profileImage'] ?? '';
          userHomeLocation = userData['homeLocation'] ?? '';
          userLanguage = userData['language'] ?? 'ar';
          userRole = userData['role'] ?? 'guardian';
        });
      } else {
        // User doesn't exist in Firestore, create new user
        await _createNewUserInFirestore();
      }
    } catch (e) {
      print('Error loading user data from Firestore: $e');
    }
  }

  /// Create new user in Firestore
  Future<void> _createNewUserInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool success = await UserDataHandler.saveNewUser(
        phoneNumber: user.phoneNumber ?? userPhone ?? '+966 0501234567',
        name: user.displayName ?? userName ?? 'Ali Mohammed',
        email: user.email ?? userEmail ?? '',
        profileImage: userProfileImage ?? '',
        homeLocation: userHomeLocation ?? '',
        language: userLanguage ?? 'ar',
        role: userRole ?? 'guardian',
      );

      if (success) {
        print('New user created in Firestore successfully');
      } else {
        print('Failed to create new user in Firestore');
      }
    }
  }

  /// Log out from Firebase and navigate to Language Selection
  Future<void> logOut() async {
    setState(() {
      loading = true;
    });

    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Clear any stored user data
      await SharedPref.logout();
      
      // Navigate to Language Selection Screen
      if (currentContext_ != null && currentContext_!.mounted) {
        GoRouter.of(currentContext_!).goNamed('language-selection');
      }
      
      setState(() {
        loading = false;
      });
      
      print('User logged out successfully');
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('Error during logout: $e');
      
      // Show error message to user
      if (currentContext_ != null && currentContext_!.mounted) {
        ScaffoldMessenger.of(currentContext_!).showSnackBar(
          SnackBar(
            content: Text('Error during logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Delete account permanently
  Future<void> deleteAccount() async {
    setState(() {
      loading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Delete the user account
        await user.delete();
        
        // Clear any stored user data
        await SharedPref.logout();
        
        // Navigate to Language Selection Screen
        if (currentContext_ != null && currentContext_!.mounted) {
          GoRouter.of(currentContext_!).goNamed('language-selection');
        }
        
        setState(() {
          loading = false;
        });
        
        print('Account deleted successfully');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('Error during account deletion: $e');
      
      // Show error message to user
      if (currentContext_ != null && currentContext_!.mounted) {
        ScaffoldMessenger.of(currentContext_!).showSnackBar(
          SnackBar(
            content: Text('Error during account deletion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Edit profile action
  void editProfile() {
    print('Edit profile tapped');
    // TODO: Implement edit profile functionality
    if (currentContext_ != null && currentContext_!.mounted) {
      ScaffoldMessenger.of(currentContext_!).showSnackBar(
        const SnackBar(content: Text('Edit profile functionality coming soon!')),
      );
    }
  }

  /// Update user profile image
  Future<void> updateProfileImage(String imageUrl) async {
    if (userId == null) return;

    setState(() {
      loading = true;
    });

    try {
      bool success = await UserDataHandler.updateUserProfileImage(userId!, imageUrl);
      if (success) {
        setState(() {
          userProfileImage = imageUrl;
        });
        if (currentContext_ != null && currentContext_!.mounted) {
          ScaffoldMessenger.of(currentContext_!).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully!')),
          );
        }
      }
    } catch (e) {
      print('Error updating profile image: $e');
      if (currentContext_ != null && currentContext_!.mounted) {
        ScaffoldMessenger.of(currentContext_!).showSnackBar(
          SnackBar(content: Text('Error updating profile image: $e')),
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  /// Update user home location
  Future<void> updateHomeLocation(String location) async {
    if (userId == null) return;

    setState(() {
      loading = true;
    });

    try {
      bool success = await UserDataHandler.updateUserHomeLocation(userId!, location);
      if (success) {
        setState(() {
          userHomeLocation = location;
        });
        if (currentContext_ != null && currentContext_!.mounted) {
          ScaffoldMessenger.of(currentContext_!).showSnackBar(
            const SnackBar(content: Text('Home location updated successfully!')),
          );
        }
      }
    } catch (e) {
      print('Error updating home location: $e');
      if (currentContext_ != null && currentContext_!.mounted) {
        ScaffoldMessenger.of(currentContext_!).showSnackBar(
          SnackBar(content: Text('Error updating home location: $e')),
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  /// Change language action
  void changeLanguage() {
    // Show language selection bottom sheet
    if (currentContext_ != null && currentContext_!.mounted) {
      showModalBottomSheet(
        context: currentContext_!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const LanguageSelectionBottomSheet(),
      );
    }
  }

  /// Change profile action
  void changeProfile() {
    print('Change profile tapped');
    // TODO: Implement change profile functionality
    if (currentContext_ != null && currentContext_!.mounted) {
      ScaffoldMessenger.of(currentContext_!).showSnackBar(
        const SnackBar(content: Text('Change profile functionality coming soon!')),
      );
    }
  }

  /// Delegator settings action
  void delegatorSettings() {
    print('Delegator settings tapped');
    // TODO: Implement delegator settings functionality
    if (currentContext_ != null && currentContext_!.mounted) {
      ScaffoldMessenger.of(currentContext_!).showSnackBar(
        const SnackBar(content: Text('Delegator settings functionality coming soon!')),
      );
    }
  }

  /// Home location action
  void homeLocation() {
    print('Home location tapped');
    // TODO: Implement home location functionality
    if (currentContext_ != null && currentContext_!.mounted) {
      ScaffoldMessenger.of(currentContext_!).showSnackBar(
        const SnackBar(content: Text('Home location functionality coming soon!')),
      );
    }
  }
}
