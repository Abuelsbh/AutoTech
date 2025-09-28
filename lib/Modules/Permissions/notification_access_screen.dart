import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:template_2025/core/Language/app_languages.dart';
import 'package:template_2025/core/Language/locales.dart';

class NotificationAccessScreen extends StatelessWidget {
  static const routeName = "/notification-access";

  const NotificationAccessScreen({super.key});

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
                        // Welcome text
                        Text(
                          "welcome_automation".tr,
                          style: GoogleFonts.inter(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 60.h),
                        
                        // Notification icon
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F7),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Bell icon
                              Icon(
                                Icons.notifications,
                                size: 60.sp,
                                color: const Color(0xFFFF9500),
                              ),
                              // Sound waves
                              Positioned(
                                right: 15.w,
                                top: 20.h,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 2.w,
                                      height: 8.h,
                                      color: const Color(0xFFFF3B30),
                                    ),
                                    SizedBox(width: 2.w),
                                    Container(
                                      width: 2.w,
                                      height: 12.h,
                                      color: const Color(0xFFFF3B30),
                                    ),
                                    SizedBox(width: 2.w),
                                    Container(
                                      width: 2.w,
                                      height: 16.h,
                                      color: const Color(0xFFFF3B30),
                                    ),
                                    SizedBox(width: 2.w),
                                    Container(
                                      width: 2.w,
                                      height: 12.h,
                                      color: const Color(0xFFFF3B30),
                                    ),
                                    SizedBox(width: 2.w),
                                    Container(
                                      width: 2.w,
                                      height: 8.h,
                                      color: const Color(0xFFFF3B30),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Request text
                        Text(
                          "notification_request".tr,
                          style: GoogleFonts.inter(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF000000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Description
                        Text(
                          "notification_desc".tr,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E93),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Action buttons
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50.h,
                            child: OutlinedButton(
                              onPressed: () {
                                GoRouter.of(context).goNamed('location-access');
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                backgroundColor: const Color(0xFFF2F2F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                              ),
                              child: Text(
                                "exit".tr,
                                style: GoogleFonts.inter(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF8E8E93),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Container(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                GoRouter.of(context).goNamed('location-access');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007AFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "allow".tr,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
