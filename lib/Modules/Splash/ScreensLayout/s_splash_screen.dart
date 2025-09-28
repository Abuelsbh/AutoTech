import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:state_extended/state_extended.dart';
import 'package:auto_tech/core/Language/locales.dart';
import '../../../generated/assets.dart';
import '../splash_controller.dart';

class SmallSplashScreen extends StatefulWidget {
  const SmallSplashScreen({super.key});

  @override
  State createState() => _SmallSplashScreenState();
}

class _SmallSplashScreenState extends StateX<SmallSplashScreen> {
  _SmallSplashScreenState() : super(controller: SplashController()) {
    con = SplashController();
  }

  late SplashController con;

  @override
  void initState() {
    con.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(Assets.imagesSplash, fit: BoxFit.contain,),
    );
  }
}
