import 'dart:math';

import 'package:state_extended/state_extended.dart';

import 'auth_data_handler.dart';

class AuthController extends StateXController {
  factory AuthController() {
    _this ??= AuthController._();
    return _this!;
  }
  static AuthController? _this;
  AuthController._();

  int? otp;

  int getRandomOTP() {
    final random = Random();
    return 1000 + random.nextInt(9000);
  }

  Future<void> sendVerificationCode({required String phoneNumber}) async {
    otp = getRandomOTP();
    final result = await AuthDataHandler.sendVerificationCode(OTP: otp??0, phoneNumber: phoneNumber);
    result.fold(
            (l) => print(l.errorModel.statusMessage), (r) {
      print(r);
    });
  }
}