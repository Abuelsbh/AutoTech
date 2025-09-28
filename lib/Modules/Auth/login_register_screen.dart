import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:template_2025/core/Language/app_languages.dart';
import 'package:template_2025/core/Language/locales.dart';

import '../../generated/assets.dart';

class LoginRegisterScreen extends StatefulWidget {
  static const routeName = "/login-register";

  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _agreeToTerms = false;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'SA'); // Default to Saudi Arabia
  String? _phoneNumberText;

  @override
  void initState() {
    super.initState();
    _initializePhoneNumber();
  }

  void _initializePhoneNumber() async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber('+966');
    if (mounted) {
      setState(() {
        _phoneNumber = number;
      });
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          List<Map<String, String>> filteredCountries = _getCountryList();
          
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                
                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Select Country",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // Countries list
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                        leading: Text(
                          country['flag']!,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        title: Text(
                          country['name']!,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        subtitle: Text(
                          country['code']!,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _phoneNumber = PhoneNumber(
                              isoCode: country['iso']!,
                              dialCode: country['code']!,
                            );
                            _phoneNumberText = "${country['code']!}${_phoneController.text}";
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getCountryList() {
    return [
      {'name': 'Saudi Arabia', 'code': '+966', 'iso': 'SA', 'flag': '🇸🇦'},
      {'name': 'United Arab Emirates', 'code': '+971', 'iso': 'AE', 'flag': '🇦🇪'},
      {'name': 'Egypt', 'code': '+20', 'iso': 'EG', 'flag': '🇪🇬'},
      {'name': 'Jordan', 'code': '+962', 'iso': 'JO', 'flag': '🇯🇴'},
      {'name': 'Kuwait', 'code': '+965', 'iso': 'KW', 'flag': '🇰🇼'},
      {'name': 'Qatar', 'code': '+974', 'iso': 'QA', 'flag': '🇶🇦'},
      {'name': 'Bahrain', 'code': '+973', 'iso': 'BH', 'flag': '🇧🇭'},
      {'name': 'Oman', 'code': '+968', 'iso': 'OM', 'flag': '🇴🇲'},
    ];
  }

  String _getCountryName(String isoCode) {
    final country = _getCountryList().firstWhere(
      (country) => country['iso'] == isoCode,
      orElse: () => {'name': 'Saudi Arabia', 'code': '+966', 'iso': 'SA', 'flag': '🇸🇦'},
    );
    return country['name']!;
  }

  String _getCountryFlag(String isoCode) {
    final country = _getCountryList().firstWhere(
      (country) => country['iso'] == isoCode,
      orElse: () => {'name': 'Saudi Arabia', 'code': '+966', 'iso': 'SA', 'flag': '🇸🇦'},
    );
    return country['flag']!;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLang = Provider.of<AppLanguage>(context);
    final isRTL = appLang.appLang == Languages.ar;
    
    return Scaffold(
      bottomNavigationBar:  Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Container(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: (_agreeToTerms && _phoneNumberText != null && _phoneNumberText!.isNotEmpty) ? () {
              // إرسال رقم الهاتف الكامل إلى الشاشة التالية
              GoRouter.of(context).goNamed('mobile-verification', extra: {
                'phoneNumber': _phoneNumberText,
                'countryCode': _phoneNumber.dialCode ?? '+966',
                'countryName': _getCountryName(_phoneNumber.isoCode ?? 'SA'),
              });
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: (_agreeToTerms && _phoneNumberText != null && _phoneNumberText!.isNotEmpty) ? const Color(0xFF007AFF) : const Color(0xFFE5E5EA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              elevation: 0,
            ),
            child: Text(
              "continue".tr,
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                color: _agreeToTerms ? Colors.white : const Color(0xFF8E8E93),
              ),
            ),
          ),
        ),
      ),
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

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // App logo
                      Image.asset(Assets.imagesLogo),

                      SizedBox(height: 20.h),

                      // Title
                      Text(
                        "happy_serve".tr,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF000000),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 20.h),

                      // Description
                      Text(
                        "register_desc".tr,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8E8E93),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 40.h),

                        // Phone number input - Custom design matching the image
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFE5E5EA),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Country selector section
                              GestureDetector(
                                onTap: () {
                                  _showCountryPicker();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                                  child: Row(
                                    children: [
                                      // Flag container
                                      Text(
                                        _getCountryFlag(_phoneNumber.isoCode ?? 'SA'),
                                        style: TextStyle(fontSize: 20.sp),
                                      ),
                                      SizedBox(width: 12.w),
                                      // Country name and code
                                      Expanded(
                                        child: Text(
                                          "${_getCountryName(_phoneNumber.isoCode ?? 'SA')} (${_phoneNumber.dialCode ?? '+966'})",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF000000),
                                          ),
                                        ),
                                      ),
                                      // Dropdown arrow
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 20.sp,
                                        color: const Color(0xFF007AFF),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Divider line
                              Container(
                                height: 1,
                                color: const Color(0xFFE5E5EA),
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                              ),
                              // Phone number input section
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Enter Phone Number",
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF8E8E93),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF000000),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _phoneNumberText = "${_phoneNumber.dialCode ?? '+966'}$value";
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 30.h),

                      // Terms and conditions
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreeToTerms = !_agreeToTerms;
                              });
                            },
                            child: Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: _agreeToTerms ? const Color(0xFF007AFF) : const Color(0xFFE5E5EA),
                                  width: 2,
                                ),
                                color: _agreeToTerms ? const Color(0xFF007AFF) : Colors.transparent,
                              ),
                              child: _agreeToTerms
                                  ? Icon(
                                Icons.check,
                                size: 14.sp,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF8E8E93),
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(text: "terms_agree".tr.split("Terms & Conditions")[0]),
                                  TextSpan(
                                    text: "terms_conditions".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF007AFF),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: " and "),
                                  TextSpan(
                                    text: "policy".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF007AFF),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: "."),
                                ],
                              ),
                            ),
                          ),
                        ],
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
}
