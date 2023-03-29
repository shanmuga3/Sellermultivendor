import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Widget/api.dart';

import '../../../Helper/Color.dart';
import '../../../Widget/networkAvailablity.dart';

class TabColor extends ChangeNotifier{
  Color _selectedColor1 = Colors.purple;
  Color _selectedColor2 = grad2Color;
  Color _selectedColor3 =Color(0xff00FFFF);
  Map<String , dynamic> _subscriptionData = {};
  Map<String , dynamic> get subscriptionData => _subscriptionData;

  Color get selectedColor1 => selectedColor1;
  Color get selectedColor2 => selectedColor2;
  Color get selectedColor3 => selectedColor3;

  void updateSelectedColorPurple(Color color)
  {
    _selectedColor1 = color;
    notifyListeners();
  }
  void updateSelectedColorOrange(Color color)
  {
    _selectedColor2 = color;
    notifyListeners();
  }
  void updateSelectedColorAqua(Color color)
  {
    _selectedColor3 = color;
    notifyListeners();
  }

  Future<Map<String,dynamic>?> fetchSubscriptionData(var parmater) async{
    try{
      _subscriptionData = await ApiBaseHelper().postAPICall(getSubscriptionData, parmater);
      notifyListeners();
    }catch(e){
      throw ApiException("Something went Wrong");
    }
  }

}