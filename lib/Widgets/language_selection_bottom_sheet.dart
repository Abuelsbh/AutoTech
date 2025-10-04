import 'package:auto_tech/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../Utilities/strings.dart';
import '../Utilities/theme_helper.dart';
import '../core/Language/app_languages.dart';

class LanguageSelectionBottomSheet extends StatelessWidget {
  const LanguageSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                  color: const Color(0xFF1F2937),
                ),
                Expanded(
                  child: Text(
                    'Change Language',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 48.w), // Balance the back button
              ],
            ),
          ),
          
          // Language options
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                _buildLanguageOption(
                  context: context,
                  flag: '🇸🇦',
                  languageName: 'العربية',
                  languageCode: 'ar',
                  isSelected: Provider.of<AppLanguage>(context).appLang == Languages.ar,
                ),
                Gap(16.h),
                _buildLanguageOption(
                  context: context,
                  flag: '🇺🇸',
                  languageName: 'English (United States)',
                  languageCode: 'en',
                  isSelected: Provider.of<AppLanguage>(context).appLang == Languages.en,
                ),
                Gap(16.h),
                _buildLanguageOption(
                  context: context,
                  flag: '🇵🇰',
                  languageName: 'اردو',
                  languageCode: 'ur',
                  isSelected: Provider.of<AppLanguage>(context).appLang == Languages.ur,
                ),
                Gap(16.h),
                _buildLanguageOption(
                  context: context,
                  flag: '🇮🇳',
                  languageName: 'தமிழ்',
                  languageCode: 'ta',
                  isSelected: Provider.of<AppLanguage>(context).appLang == Languages.ta,
                ),
                Gap(20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String flag,
    required String languageName,
    required String languageCode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        // Change language
        final appLanguage = Provider.of<AppLanguage>(context, listen: false);
        final newLanguage = Languages.values.firstWhere(
          (lang) => lang.name == languageCode,
          orElse: () => Languages.en,
        );
        
        appLanguage.changeLanguage();
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F4F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF0D5EA6) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            ),
            
            Gap(16.w),
            
            // Language name
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
            
            // Radio button
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0D5EA6) : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF0D5EA6) : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
