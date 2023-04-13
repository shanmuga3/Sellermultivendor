import 'package:flutter/cupertino.dart';

import '../../../Model/ProductModel/Product.dart';

class ProductListProviderSearch with ChangeNotifier{
  List<Product> _allProduct = [];
  List<Product> _filteredProduct = [];

  List<Product> get allProduct => _allProduct;
  List<Product> get filteredProduct => _filteredProduct;

  void filteredProductData(String query){
    if(query.isEmpty){
      _filteredProduct = _allProduct;
    }
    else{
      _filteredProduct = _allProduct.where((product) => product.name!.toLowerCase().contains(query.toLowerCase())).toList();
    }
    notifyListeners();
  }
}