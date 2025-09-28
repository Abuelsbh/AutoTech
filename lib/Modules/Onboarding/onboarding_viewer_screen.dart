import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:template_2025/core/Language/app_languages.dart';
import 'package:template_2025/core/Language/locales.dart';

import '../../generated/assets.dart';

class OnboardingViewerScreen extends StatefulWidget {
  static const routeName = "/onboarding";

  const OnboardingViewerScreen({super.key});

  @override
  State<OnboardingViewerScreen> createState() => _OnboardingViewerScreenState();
}

class _OnboardingViewerScreenState extends State<OnboardingViewerScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      GoRouter.of(context).goNamed('notification-access');
    }
  }

  void _skipToEnd() {
    GoRouter.of(context).goNamed('notification-access');
  }

  @override
  Widget build(BuildContext context) {
    final appLang = Provider.of<AppLanguage>(context);
    final isRTL = appLang.appLang == Languages.ar;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildOnboardingPage(
                      image: Assets.imagesSplash1,
                      title: "onboarding1_title".tr,
                      description: "onboarding1_desc".tr,
                    ),
                    _buildOnboardingPage(
                      image: Assets.imagesSplash2,
                      title: "onboarding2_title".tr,
                      description: "onboarding2_desc".tr,
                    ),
                    _buildOnboardingPage(
                      image: Assets.imagesSplash3,
                      title: "onboarding3_title".tr,
                      description: "onboarding3_desc".tr,
                    ),
                  ],
                ),
              ),

              /// Indicators + Button
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: _currentPage == index ? 24.w : 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF1E40AF)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E40AF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == 2
                              ? "get_started".tr
                              : "next".tr,
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
    );
  }

  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// صورة + زر Skip فوقها
            Stack(
              children: [
                Image.asset(
                  image,
                  width: double.infinity,
                  height: 510.h, // تقليل الارتفاع لتجنب التجاوز
                  fit: BoxFit.contain, // تغيير من fitWidth إلى contain
                ),

                /// زر Skip فوق الصورة
                if (_currentPage > 0)
                  Positioned(
                    top: 40.h,
                    right: 20.w,
                    child: TextButton(
                      onPressed: _skipToEnd,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        "skip".tr,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 30.h), // تقليل المسافة
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 24.sp, // تقليل حجم الخط قليلاً
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h), // تقليل المسافة
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 15.sp, // تقليل حجم الخط قليلاً
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.5, // تقليل ارتفاع السطر قليلاً
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h), // إضافة مسافة في النهاية
          ],
        ),
      ),
    );
  }

}
