import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';

import '../../../Widget/api.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/sharedPreferances.dart';

class SubscriptionProvider extends ChangeNotifier {
  List _subscriptionList = [];
  List _checkSubscriptionData = [];
  String _subscription_name = "";
  String get  subscription_name => _subscription_name;
  List get subscriptionList => _subscriptionList;
  List get checkSubscriptionData => _checkSubscriptionData;

  Future<void> fetchSubscriptionData() async {
    Map parameter = {};
    ApiBaseHelper().postAPICall(getSubscriptionData, parameter).then((getData) {
      _subscriptionList = getData["rows"];
      print("dataaaaa ${_subscriptionList}");
      notifyListeners();
    });
  }

  Future<void> checkSubscriptionofSeller(BuildContext context) async {
    context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
    var parameter = {SellerId: context.read<SettingProvider>().CUR_USERID};
    print('hreee2'+"selllerid"+ context.read<SettingProvider>().CUR_USERID.toString());
    ApiBaseHelper().postAPICall(checkSubscription, parameter).then((getData) async{
      _checkSubscriptionData = getData["data"];
    //  final data = getData["data"];
      _subscription_name = getData["data"][0]['subscription_name'];
      print("nameisssss ${_subscription_name}");
    //  _startDate = getData["data"][0]["start_date"].toString();
      bool isSubscribed = _checkSubscriptionData.isNotEmpty;
      if (isSubscribed) {
        // show already subscribed page
        print("show already subscribed pag" );
        //Navigator.pushNamed(context, '/alreadySubscribed');
      } else {
        // show subscribe page
        print("not already subscribed pag" );
       // Navigator.pushNamed(context, '/subscribe');
      }
      notifyListeners();
    });
  }


}
//
//
