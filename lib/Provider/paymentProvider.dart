import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';

import '../Helper/Constant.dart';
import '../Repository/paymentMethodRepository.dart';
import '../Widget/networkAvailablity.dart';


class PaymentProvider extends ChangeNotifier {
  List<String?> paymentMethodList = [];
  // List<Model> timeSlotList = [];
  // List<RadioModel> timeModel = [];
  // List<RadioModel> payModel = [];
  // List<RadioModel> timeModelList = [];
  String? allowDay;
  List<String> paymentIconList = [
    Platform.isIOS ? 'applepay' : 'gpay',
    'cod_payment',
    'paypal',
    'payu',
    'rozerpay',
    'paystack',
    'flutterwave',
    'stripe',
    'paytm',
    'banktransfer',
    'midtrans',
    'myfatoorah',
  ];
  bool codAllowed = true;
  bool isLoading = true;
  String? startingDate;
  String? bankName, bankNo, acName, acNo, exDetails;
  late bool cod,
      paypal,
      razorpay,
      paumoney,
      paystack,
      flutterwave,
      stripe,
      paytm = true,
      gpay = false,
      bankTransfer = true,
      midtrans,
      myfatoorah;

  Future<void> getdateTime(
    BuildContext context,
    Function updateNow,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
     // timeSlotList.clear();
      try {
        var parameter = {'type': 'payment_method', 'user_id': context.read<SettingProvider>().CUR_USERID};
        Map<String, dynamic> result =
            await PaymentRepository.getDataTimeSettings(parameter: parameter);
        bool error = result['error'];

        if (!error) {
          var data = result['data'];
          var timeSlot = data['time_slot_config'];
          allowDay = timeSlot['allowed_days'];


          var payment = data['payment_method'];
          // cod = codAllowed
          //     ? payment['cod_method'] == '1'
          //         ? true
          //         : false
          //     : false;
          // paypal = payment['paypal_payment_method'] == '1' ? true : false;
          // paumoney = payment['payumoney_payment_method'] == '1' ? true : false;
          // flutterwave =
          //     payment['flutterwave_payment_method'] == '1' ? true : false;
          // razorpay = payment['razorpay_payment_method'] == '1' ? true : false;
          // paystack = payment['paystack_payment_method'] == '1' ? true : false;
          // stripe = payment['stripe_payment_method'] == '1' ? true : false;
          // paytm = payment['paytm_payment_method'] == '1' ? true : false;
          // bankTransfer = payment['direct_bank_transfer'] == '1' ? true : false;
          // midtrans = payment['midtrans_payment_method'] == '1' ? true : false;
          myfatoorah =
              payment['myfaoorah_payment_method'] == '1' ? true : false;
          if (myfatoorah) {
     myfatoorahToken =
                payment['myfatoorah_token'];
           myfatoorahPaymentMode =
                payment['myfatoorah_payment_mode'];
         myfatoorahSuccessUrl =
                payment['myfatoorah__successUrl'];
         myfatoorahErrorUrl =
                payment['myfatoorah__errorUrl'];
           myfatoorahLanguage =
                payment['myfatoorah_language'];
        myfatoorahCountry =
                payment['myfatoorah_country'];
          }

        } else {}

        isLoading = false;
        updateNow();
      } on TimeoutException catch (_) {}
    } else {
      isNetworkAvail = false;
      updateNow();
    }
  }








// call after payment success

}
