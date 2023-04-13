import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sellermultivendor/Screen/completeinfo/provider/allcategory_repository.dart';
import 'package:sellermultivendor/Widget/api.dart';

import '../../../Model/CategoryModel/categoryModel.dart';

class AllCategoryProvider extends ChangeNotifier {
  List _categoryName = [];

  List get categoryName => _categoryName;
  String errorMessage = '';

  Future<bool> fetchCategory(BuildContext context) async {
    try {
      var parameter = {};
      var result =
          await AllCatSystemRepository.fetchallCategories(parameter: parameter);
      bool error = result['error'];
      //  errorMessage = result['message'];
      print("here==> 0");
      if (!error) {
        print("here==> 1");
        var data = result['data'];

        _categoryName = (data as List).map((data) => data['name']).toList();
        print("category==> ${_categoryName}");
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
