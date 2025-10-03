import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_tech/core/Language/app_languages.dart';
import 'package:auto_tech/core/Language/locales.dart';
import 'package:auto_tech/Modules/Auth/auth_controller.dart';

import '../../generated/assets.dart';

class RoleSelectionScreen extends StatefulWidget {
  static const routeName = "/role-selection";

  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    selectedRole = "guardian"; // Default selection
    // تعيين الدور الافتراضي في AuthController
    _authController.setSelectedRole("guardian");
  }

  @override
  Widget build(BuildContext context) {
    final appLang = Provider.of<AppLanguage>(context);
    final isRTL = appLang.appLang == Languages.ar;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  

                  

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.imagesLogo),

                        SizedBox(height: 40.h),
                        
                        // Title
                        Text(
                          "select_role".tr,
                          style: GoogleFonts.inter(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Description
                        Text(
                          "role_desc".tr,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E93),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Role options
                        Column(
                          children: [
                            _buildRoleOption("guardian", "guardian_parent".tr),
                            SizedBox(height: 16.h),
                            _buildRoleOption("staff", "school_staff".tr),
                            SizedBox(height: 16.h),
                            _buildRoleOption("driver", "bus_driver".tr),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Continue button
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).goNamed('login-register');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          selectedRole == "guardian" ? "continue_as".tr : 
                          selectedRole == "staff" ? "Continue as School Staff".tr : 
                          "Continue as Bus Driver".tr,
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String value, String title) {
    final isSelected = selectedRole == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = value;
        });
        // حفظ الدور المختار في AuthController
        _authController.setSelectedRole(value);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFE5E5EA),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFE5E5EA),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

