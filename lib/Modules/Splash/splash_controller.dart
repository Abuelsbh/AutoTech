import 'package:flutter/cupertino.dart';
import 'package:state_extended/state_extended.dart';
import '../../Utilities/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SplashController extends StateXController {
  // singleton
  factory SplashController() {
    _this ??= SplashController._();
    return _this!;
  }
  static SplashController? _this;
  SplashController._();

  Future init(BuildContext context)async{
    await Future.delayed(const Duration(seconds: 3));
    if(context.mounted) {
      if(SharedPref.isLogin()){
        GoRouter.of(context).goNamed('home');
      }else{
        GoRouter.of(context).goNamed('home');
      }
    }
  }
}
