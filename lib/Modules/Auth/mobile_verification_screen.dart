import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:state_extended/state_extended.dart';
import 'package:template_2025/Modules/Auth/auth_controller.dart';
import 'package:template_2025/core/Language/app_languages.dart';
import 'package:template_2025/core/Language/locales.dart';

import '../../generated/assets.dart';

class MobileVerificationScreen extends StatefulWidget {
  static const routeName = "/mobile-verification";

  const MobileVerificationScreen({super.key, this.phoneData});

  final Map<String, dynamic>? phoneData;

  @override
  _MobileVerificationScreenState createState() => _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends StateX<MobileVerificationScreen> {
  _MobileVerificationScreenState() : super(controller: AuthController()) {
    con = AuthController();
  }
  late AuthController con;


  final TextEditingController _pinController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 119; // 1:59
  bool _canResend = false;
  late String _phoneNumber;
  late String _countryCode;
  late String _countryName;

  @override
  void initState() {
    super.initState();
    
    // استقبال البيانات من الشاشة السابقة
    if (widget.phoneData != null) {
      _phoneNumber = widget.phoneData!['phoneNumber'] ?? '+966501234567';
      _countryCode = widget.phoneData!['countryCode'] ?? '+966';
      _countryName = widget.phoneData!['countryName'] ?? 'Saudi Arabia';
    } else {
      _phoneNumber = '+966501234567';
      _countryCode = '+966';
      _countryName = 'Saudi Arabia';
    }
    
    con.sendVerificationCode(phoneNumber: _phoneNumber);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }
//4969309
  //4969508
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }
  bool _isError = false;
  void _resendCode() {
    if (_canResend) {
      setState(() {
        _remainingSeconds = 119;
        _canResend = false;
      });
      _startTimer();
      // Here you would typically call your API to resend the code
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final appLang = Provider.of<AppLanguage>(context);
    final isRTL = appLang.appLang == Languages.ar;
    
    // Configure the default pin theme
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF000000),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF007AFF), width: 1),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border.all(color: const Color(0xFF007AFF), width: 2),
    // );

    // final submittedPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border.all(color: const Color(0xFF34C759), width: 1),
    // );
    final errorPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: TextStyle(fontSize: 20, color: Colors.red),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );

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

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // App logo
                       Image.asset(Assets.imagesLogo),

                        SizedBox(height: 10.h),

                        // App name around logo
                        Text(
                          "AUTOMATION TECHNOLOGY",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8E8E93),
                            letterSpacing: 1.2,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Title
                        Text(
                          "mobile_verification".tr,
                          style: GoogleFonts.inter(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 30.h),

                        // Instructions
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8E8E93),
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(text: "verification_code_sent".tr + " "),
                              TextSpan(
                                text: _phoneNumber,
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF007AFF),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // Resend section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "didnt_receive_code".tr,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF8E8E93),
                              ),
                            ),
                            Row(
                              children: [
                                if (!_canResend) ...[
                                  Text(
                                    _formatTime(_remainingSeconds),
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF34C759),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                                GestureDetector(
                                  onTap: _canResend ? _resendCode : null,
                                  child: Text(
                                    "resend_code".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: _canResend ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 30.h),

                        Pinput(
                          controller: _pinController,
                          length: 4,
                          defaultPinTheme: _isError ? errorPinTheme : defaultPinTheme,
                          focusedPinTheme: _isError ? errorPinTheme : defaultPinTheme,
                          submittedPinTheme: _isError ? errorPinTheme : defaultPinTheme,
                          showCursor: true,
                          onCompleted: (pin) {
                            if (pin == con.otp.toString()) {
                              GoRouter.of(context).goNamed('home');
                            } else {
                              setState(() {
                                _isError = true; // change to red
                              });
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),

                        SizedBox(height: 20.h),

                        // Contact support
                        GestureDetector(
                          onTap: () {
                            // Handle contact support
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF8E8E93),
                              ),
                              children: [
                                TextSpan(text: "If you didn't receive the code yet, "),
                                TextSpan(
                                  text: "contact_support".tr,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF007AFF),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
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
