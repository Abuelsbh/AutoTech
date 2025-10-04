import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String name;
  final String? profileImage; // Base64 encoded image or network URL
  final bool hasNotification;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const CustomAppBarWidget({
    super.key,
    required this.name,
    this.profileImage,
    this.hasNotification = false,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Greeting Text
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hey, ',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4B5563), // Dark blue-gray
                      ),
                    ),
                    TextSpan(
                      text: name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937), // Darker blue
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Notification Icon
            _buildNotificationIcon(),
            
            SizedBox(width: 12.w),
            
            // Profile Icon
            _buildProfileIcon(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(76.h); // Height for SafeArea + content

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: onNotificationTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6), // Light gray background
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.notifications_outlined,
                size: 20.sp,
                color: const Color(0xFF4B5563), // Dark blue-gray
              ),
            ),
            // Notification badge
            if (hasNotification)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444), // Red color
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6), // Light gray background
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: _buildProfileImage(),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (profileImage != null && profileImage!.isNotEmpty) {
      // Check if it's a base64 image
      if (profileImage!.startsWith('data:image') || 
          profileImage!.startsWith('/9j/') || 
          profileImage!.startsWith('iVBORw0KGgo')) {
        try {
          // Handle base64 image
          String base64String = profileImage!;
          if (base64String.startsWith('data:image')) {
            base64String = base64String.split(',')[1];
          }
          
          Uint8List bytes = base64Decode(base64String);
          return Image.memory(
            bytes,
            width: 44.w,
            height: 44.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultAvatar();
            },
          );
        } catch (e) {
          return _buildDefaultAvatar();
        }
      } else {
        // Handle network image
        return Image.network(
          profileImage!,
          width: 44.w,
          height: 44.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        );
      }
    }
    
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E7EB), // Light gray
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_outline,
        size: 20.sp,
        color: const Color(0xFF9CA3AF), // Medium gray
      ),
    );
  }

}
