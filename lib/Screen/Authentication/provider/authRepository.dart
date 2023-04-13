import '../../../Helper/ApiBaseHelper.dart';
import '../../../Widget/api.dart';

class AuthRepository {
  //
  //This method is used to fetch System policies {e.g. Privacy Policy, T&C etc..}
  static Future<Map<String, dynamic>> fetchLoginData({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(getUserLoginApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$errorMesaage${e.toString()}');
    }
  }

  //validate referl code

  static Future<Map<String, dynamic>> fetchverificationData({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(verifyUserApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$errorMesaage${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> fetchSingUpData({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(registerApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$errorMesaage${e.toString()}');
    }
  }

  // static Future<Map<String, dynamic>> fetchFetchReset({
  //   required Map<String, dynamic> parameter,
  // }) async {
  //   try {
  //     var loginDetail =
  //         await ApiBaseHelper().postAPICall(getResetPassApi, parameter);
  //
  //     return loginDetail;
  //   } on Exception catch (e) {
  //     throw ApiException('$errorMesaage${e.toString()}');
  //   }
  // }
}
