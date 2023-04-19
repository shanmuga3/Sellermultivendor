import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';

import '../../../Widget/api.dart';

class CityRepository {
  //
  //This method is used to fetch System policies {e.g. Privacy Policy, T&C etc..}
  static Future<Map<String, dynamic>> fetchallCity( {required Map<dynamic, dynamic> parameter}) async {
    try {
      var data = await ApiBaseHelper().postAPICall(allCitiesApi, parameter);

      return data;
    } on Exception catch (e) {
      throw ApiException('Something went wrong');
    }
  }
}

class CityProvider extends ChangeNotifier {
  List _cityName = [];

  List get cityName => _cityName;
  String errorMessage = '';

  Future<bool> fetchCity(BuildContext context) async {
    try {
      var parameter = {};
      var result =
      await CityRepository.fetchallCity(parameter: parameter);
      bool error = result['error'];
      //  errorMessage = result['message'];
      print("here==> 0");
      if (!error) {
        print("here==> 1");
        var data = result['data'];

        _cityName = (data as List).map((data) => data['name']).toList();
        print("category==> ${_cityName}");
        return false;
      }
      return true;
    } catch (e) {
      print("here==> 2");

      errorMessage = e.toString();
      return true;
    }
  }
}


class City {
  final String id;
  final String name;

  City({required this.id, required this.name});
}
