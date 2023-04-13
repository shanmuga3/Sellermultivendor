import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import '../Model/CategoryModel/categoryModel.dart';
import '../Repository/categoryRepositry.dart';
import '../Screen/AddProduct/Add_Product.dart';
import '../Screen/EditProduct/EditProduct.dart';
import '../Widget/parameterString.dart';

class CategoryProvider extends ChangeNotifier {
  List _categoryName = [];
  List get categoryName => _categoryName;
  String errorMessage = '';

  Future<bool> fetchCategory(BuildContext context) async {
    try {
      var parameter = {
        SellerId: context.read<SettingProvider>().currentUerID,
      };
      var result = await CategoryRepository.setCategory(parameter: parameter);
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        var data = result['data'];
        _categoryName = (data as List)
            .map((data) => CategoryModel.fromJson(data).name)
            .toList();
        return false;
      }
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }
  Future<bool> setCategory(bool fromAddProduct, BuildContext context) async {
    try {
      var parameter = {
        SellerId: context.read<SettingProvider>().currentUerID,
      };
      var result = await CategoryRepository.setCategory(parameter: parameter);
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        var data = result['data'];
        // _categoryName = (data as List).map((data) => CategoryModel.fromJson(data)).cast<String>().toList();
        print("dataof ===> ${_categoryName}");
        if (fromAddProduct) {
          addProvider!.catagorylist.clear();
          addProvider!.catagorylist = (data as List)
              .map((data) => CategoryModel.fromJson(data))
              .toList();
        } else {
          editProvider!.catagorylist.clear();
          editProvider!.catagorylist = (data as List)
              .map((data) => CategoryModel.fromJson(data))
              .toList();
        }
      }
      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }
}
