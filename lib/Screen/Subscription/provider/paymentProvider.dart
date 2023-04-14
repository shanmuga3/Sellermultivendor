import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';

import '../../../Widget/api.dart';

class PaymentProviderFatoora with ChangeNotifier {
  var _paymentMethods;
  var _paymentMode;
  String _myfatooralanguage = "";
  String _myfatooraCountry = "";
  String get myfatooraCountry => _myfatooraCountry;
  String get myfatooralanguage => _myfatooralanguage;
  get paymentMode => _paymentMode;
  String _successUrl = '';
  String _errorUrl = '';
  String _token = '';
  String get errorUrl => _errorUrl;
  String get token => _token;
  String get successUrl => _successUrl;
  get paymentMethods => _paymentMethods;
  bool _isProgress = false;
  //late bool myfatooorahh;
  get isProgress => _isProgress;

  setProgress(bool progress) {
    _isProgress = progress;
    notifyListeners();
  }

  Future<void> getPaymentMethod(BuildContext context) async {
    var parameter = {"type": "payment_method"};
    ApiBaseHelper().postAPICall(getSettingApi, parameter).then((getdata) async {
      final data = getdata['data'];
      final paymentMethod = data['payment_method'];
      _paymentMethods = paymentMethod["myfaoorah_payment_method"];
      bool myfatooorahh =
          paymentMethod["myfaoorah_payment_method"] == '1' ? true : false;
      if (myfatooorahh) {
        _token = paymentMethod['myfatoorah_token'];
        _paymentMode = paymentMethod['myfatoorah_payment_mode'];
        _successUrl = paymentMethod['myfatoorah__successUrl'];
        _myfatooralanguage = paymentMethod["myfatoorah_language"];
        _errorUrl = paymentMethod["myfatoorah__errorUrl"];
        _myfatooraCountry = paymentMethod["myfatoorah_country"];
        print(
            "datass toke ==> ${_token} ${_paymentMode} ${_successUrl} ${_myfatooraCountry} ${_myfatooralanguage}");
      }

      // final myfatoorahSuccessUrl = paymentMethod['myfatoorah__successUrl'];
      // _successUrl = myfatoorahSuccessUrl.toString();
      // _errorUrl = paymentMethod['myfatoorah__errorUrl'];
      // _token = paymentMethod['myfatoorah_token'];
      // print(myfatoorahSuccessUrl.toString()+'ghjghjgjhg');
      // bool isSubscribed = data.isNotEmpty;
      // if (isSubscribed) {
      //   // show already subscribed page
      //   print("payment availabl" +myfatoorahSuccessUrl.toString() +_token.toString());
      //   //Navigator.pushNamed(context, '/alreadySubscribed');
      // } else {
      //   // show subscribe page
      //   print("payment not availabl" );
      //   // Navigator.pushNamed(context, '/subscribe');
      // }
      notifyListeners();
    });
  }
}
