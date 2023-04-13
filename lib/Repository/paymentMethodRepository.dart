
import '../Helper/ApiBaseHelper.dart';
import '../Helper/Constant.dart';

import '../Widget/api.dart';

class PaymentRepository {
  //
//This method is used to fetch available payment methods
  static Future<Map<String, dynamic>>
      fetchAvailablePaymentMethodsAndPaymentGatewayIDs({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var systemSetting =
          await ApiBaseHelper().postAPICall(getSettingApi, parameter);

      return {
        'error': systemSetting['error'],
        'message': systemSetting['message'],
        'paymentMethods': systemSetting['data']['payment_method']
      };
    } on Exception catch (e) {
      throw ApiException('${e.toString()}');
    }
  }


  //getOrderDate and time and other settings
  //
  static Future<Map<String, dynamic>> getDataTimeSettings({
    required var parameter,
  }) async {
    try {
      var responseData = await ApiBaseHelper().postAPICall(
        getSettingApi,
        parameter,
      );

      return responseData;
    } on Exception catch (e) {
      throw ApiException('${e.toString()}');
    }
  }
}
