import 'package:auto_tech/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';

import '../../Utilities/text_style_helper.dart';
import '../../Utilities/theme_helper.dart';
import '../../Utilities/strings.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar_widget.dart';
import '../../generated/assets.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends StateX<ProfileScreen> {
  _ProfileScreenState() : super(controller: ProfileController()) {
    con = ProfileController();
  }
  late ProfileController con;

  @override
  void initState() {
    super.initState();
    con.initUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesBackground),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListView(
            children: [
              // Header with curved blue background
              _buildHeader(),

              // User Information Section
              _buildUserInfoSection(),

              // Actions Section
              _buildActionsSection(),

              const Spacer(),
            ],
          ),
          
          // Loading overlay
          if (con.loading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarWidget(selected: SelectedBottomNavBar.profile),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 220.h,
      child: Stack(
        children: [
          // Curved blue background with custom shape
          Positioned.fill(
            child: CustomPaint(
              painter: CurvedHeaderPainter(),
            ),
          ),

          // Profile image and edit button
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  // Profile image
                  Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _buildProfileImage(),
                    ),
                  ),

                  // Edit button
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: _editProfile,
                      child: Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00058C),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    // For now, using a placeholder. You can replace this with actual user image
    return Container(
      color: const Color(0xFFE5E7EB),
      child: const Icon(
        Icons.person,
        size: 50,
        color: Color(0xFF9CA3AF),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person_outline,
            label: Strings.name.tr,
            value: con.userName ?? 'Ali Mohammed',
          ),
          Gap(16.h),
          _buildInfoRow(
            icon: Icons.phone,
            label: '${Strings.phone.tr} :',
            value: con.userPhone ?? '+966 0501234567',
          ),
          Gap(16.h),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: '${Strings.registeredOn.tr} :',
            value: '23 June 2023, 09:10 PM',
          ),
          Gap(16.h),
          _buildInfoRow(
            icon: Icons.people_outline,
            label: '${Strings.currentProfileType.tr} :',
            value: Strings.guardianDelegate.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF0D5EA6),
          size: 20.sp,
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyleHelper.of(context).s12RegTextStyle.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
              Gap(2.h),
              Text(
                value,
                style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.actions.tr,
            style: TextStyleHelper.of(context).s16RegTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          Gap(16.h),

          _buildActionButton(
            icon: Icons.language,
            title: Strings.changeLanguage.tr,
            onTap: _changeLanguage,
          ),
          Gap(12.h),

          _buildActionButton(
            icon: Icons.person_outline,
            title: Strings.changeProfile.tr,
            onTap: _changeProfile,
          ),
          Gap(12.h),

          _buildActionButton(
            icon: Icons.people_outline,
            title: Strings.delegatorSettings.tr,
            onTap: _delegatorSettings,
          ),
          Gap(12.h),

          _buildActionButton(
            icon: Icons.home_outlined,
            title: Strings.homeLocation.tr,
            onTap: _homeLocation,
          ),
          Gap(12.h),

          _buildActionButton(
            icon: Icons.logout,
            title: Strings.logOut.tr,
            onTap: _logOut,
          ),
          Gap(12.h),

          _buildActionButton(
            icon: Icons.delete_forever,
            title: Strings.deleteAccountPermanently.tr,
            onTap: _deleteAccount,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF0D5EA6),
              size: 20.sp,
            ),
            Gap(12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                  color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF9CA3AF),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _editProfile() {
    con.editProfile();
  }

  void _changeLanguage() {
    con.changeLanguage();
  }

  void _changeProfile() {
    con.changeProfile();
  }

  void _delegatorSettings() {
    con.delegatorSettings();
  }

  void _homeLocation() {
    con.homeLocation();
  }

  void _logOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.logOut.tr),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              con.logOut();
            },
            child: Text(Strings.logOut.tr),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.deleteAccountPermanently.tr),
        content: Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              con.deleteAccount();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: Text(Strings.deleteAccountPermanently.tr),
          ),
        ],
      ),
    );
  }
}

// Custom painter for curved header shape
class CurvedHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00058C)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Go to top-right
    path.lineTo(size.width, 0);

    // Go down the right side
    path.lineTo(size.width, size.height * 0.25);

    // Create smooth curve at the bottom
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.95,
      0,
      size.height * 0.25,
    );

    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom clipper for the SVG background
class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Go to top-right
    path.lineTo(size.width, 0);

    // Go down the right side
    path.lineTo(size.width, size.height * 0.65);

    // Create smooth curve at the bottom
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.95,
      0,
      size.height * 0.65,
    );

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}