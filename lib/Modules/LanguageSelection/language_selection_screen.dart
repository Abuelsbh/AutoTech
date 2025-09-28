import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_tech/core/Language/app_languages.dart';
import 'package:auto_tech/core/Language/locales.dart';

import '../../generated/assets.dart';

class LanguageSelectionScreen extends StatefulWidget {
  static const routeName = "/language-selection";

  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Languages? selectedLanguage;

  @override
  void initState() {
    super.initState();
    final appLang = Provider.of<AppLanguage>(context, listen: false);
    selectedLanguage = appLang.appLang;
  }

  @override
  Widget build(BuildContext context) {
    final appLang = Provider.of<AppLanguage>(context);
    final isRTL = appLang.appLang == Languages.ar;
    
    return Scaffold(
      bottomNavigationBar:   Container(
        width: double.infinity,
        height: 56.h,
        margin: EdgeInsets.only(bottom: 30.h),
        child: ElevatedButton(
          onPressed: () {
            if (selectedLanguage != null) {
              appLang.changeLanguage(language: selectedLanguage);
                          GoRouter.of(context).goNamed('onboarding');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E40AF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            elevation: 0,
          ),
          child: Text(
            "continue".tr,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
        child: SafeArea(
          child: Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListView(
                children: [
                  

                  Image.asset(Assets.imagesLogo,height: 138.h,),

                  // Title
                  Text(
                    "select_language".tr,
                    style: GoogleFonts.cairo(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  
                  // Subtitle
                  Text(
                    "unlock_global".tr,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50.h),
                  
                  // Language Options
                  Column(
                    children: [
                      _buildLanguageOption(
                        language: Languages.ar,
                        name: "arabic".tr,
                        flag: "🇸🇦",
                      ),
                      SizedBox(height: 16.h),
                      _buildLanguageOption(
                        language: Languages.en,
                        name: "english".tr,
                        flag: "🇺🇸",
                      ),
                      SizedBox(height: 16.h),
                      _buildLanguageOption(
                        language: Languages.ur, // Using Arabic for Urdu for now
                        name: "urdu".tr,
                        flag: "🇵🇰",
                      ),
                      SizedBox(height: 16.h),
                      _buildLanguageOption(
                        language: Languages.ta, // Using Arabic for Tagalog for now
                        name: "tagalog".tr,
                        flag: "🇵🇭",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required Languages language,
    required String name,
    required String flag,
  }) {
    final isSelected = selectedLanguage == language;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            Radio<Languages>(
              value: language,
              groupValue: selectedLanguage,
              onChanged: (Languages? value) {
                setState(() {
                  selectedLanguage = value;
                });
              },
              activeColor: const Color(0xFF1E40AF),
            ),
          ],
        ),
      ),
    );
  }
}
