import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/api.dart';

import '../../../Widget/parameterString.dart';
import '../../../Widget/sharedPreferances.dart';

class fetchCampaignDataProvider extends ChangeNotifier{
  List _campaignList = [];
  String _campaignName =  "";
  String _campaignDesc =  "";
  String get campaignName => _campaignName;
  String get campaignDesc => _campaignDesc;
  List get campaignList => _campaignList;
  
  Future<void> fetchCampaignData(BuildContext context) async{
    context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
    print('hereee => 1');
    var parameter = {SellerId: context.read<SettingProvider>().CUR_USERID};
    print('hereee => 2');
    ApiBaseHelper().postAPICall(availableCampaignApi, parameter).then((getData){
      _campaignList = getData["data"];
      _campaignName = getData["data"][0]["title"];
      _campaignDesc = getData["data"][0]["description"];
      bool isAvailable = _campaignList.isNotEmpty;
      if(isAvailable){
        print("data available");
      }else{
        print("data not available");
      }
      notifyListeners();
    });
    print('hereee => 3 ${parameter}');

  }


}