
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Repository/paymentMethodRepository.dart';

enum SystemProviderPolicyStatus {
  initial,
  inProgress,
  isSuccsess,
  isFailure,
  isMoreLoading,
}

class SystemProviderNew extends ChangeNotifier {
  SystemProviderPolicyStatus _systemProviderPolicyStatus =
      SystemProviderPolicyStatus.initial;
  List<String> langCode = [
    'en',
    'zh',
    'es',
    'fr',
    'hi',
    'ar',
    'ru',
    'ja',
    'de'
  ];

  int currentLanguage = 0, selectedPaymentMethodIndex = 0;

  String errorMessage = '';
  String policy = '';

  String? midtransPaymentMode,
      midtransPaymentMethod,
      midtrashClientKey,
      midTranshMerchandId,
      midtransServerKey;

  String? myfatoorahToken,
      myfatoorahPaymentMode,
      myfatoorahSuccessUrl,
      myfatoorahErrorUrl,
      myfatoorahLanguage,
      myfatoorahCosuntry;

  bool? isPaypalEnable,
      isRazorpayEnable,
      paumoney,
      isPayStackEnable,
      isFlutterWaveEnable,
      isStripeEnable,
      isPaytmEnable,
      isMidtrashEnable,
      isMyFatoorahEnable,
      isPaytmOnTestMode = true;

  String? razorpayId,
      payStackKeyID,
      stripePublishKey,
      stripeSecretKey,
      stripePaymentMode = 'test',
      stripeCurrencyCode,
      paytmMerchantID,
      paytmMerchantKey,
      selectedPaymentMethodName;
  List<String?> paymentMethodList = [];
  List<String> paymentIconList = [
    'myfatoorah',
  ];


  get getCurrentStatus => _systemProviderPolicyStatus;

  changeStatus(SystemProviderPolicyStatus status) {
    _systemProviderPolicyStatus = status;
    notifyListeners();
  }

  //get System Policies
  Future<void> fetchAvailablePaymentMethodsAndAssignIDs(
      {required String settingType}) async {
    try {
      var parameter = {"type": settingType};
      var result = await PaymentRepository
          .fetchAvailablePaymentMethodsAndPaymentGatewayIDs(
          parameter: parameter);

      if (!result['error']) {
        var payment = result['paymentMethods'];
        print('hereerreenbgnbnmbnm');
        isMyFatoorahEnable =
        payment['myfaoorah_payment_method'] == '1' ? true : false;


        if (isMyFatoorahEnable!) {
          myfatoorahToken = payment['myfatoorah_token'];
          myfatoorahPaymentMode = payment['myfatoorah_payment_mode'];
          myfatoorahSuccessUrl = payment['myfatoorah__successUrl'];
          myfatoorahErrorUrl = payment['myfatoorah__errorUrl'];
          myfatoorahLanguage = payment['myfatoorah_language'];
          myfatoorahCosuntry = payment['myfatoorah_country'];
        }



      }
    } catch (e) {}
  }
}
