import 'package:fast_http/core/API/generic_request.dart';
import 'package:fast_http/core/API/request_method.dart';
import 'package:fast_http/core/Error/exceptions.dart';
import 'package:fast_http/core/Error/failures.dart';

import '../../Models/user_model.dart';
import '../../Utilities/api_end_point.dart';

class AuthDataHandler{
  static Future<Either<Failure,UserModel>> sendVerificationCode({required int OTP, required String phoneNumber})async{
    try {
      UserModel response = await GenericRequest<UserModel>(
        method: RequestApi.post(url: APIEndPoint.verificationCode,
            headers: {
              "Authorization": "Bearer 6f952f1dd7d280eaa0427255cc856f4e7e24b0a8ed18f35ec48970a246ea2230",
              "Content-Type": "application/json"
            },
            body: {
              "to": phoneNumber,
              "text": "Hello your verification code is $OTP"
            }),
        fromMap: (data)=> UserModel.fromJson(data),
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}