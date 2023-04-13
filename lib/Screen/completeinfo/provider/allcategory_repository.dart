import 'package:sellermultivendor/Widget/api.dart';

import '../../../Helper/ApiBaseHelper.dart';

class AllCatSystemRepository {
  //
  //This method is used to fetch System policies {e.g. Privacy Policy, T&C etc..}
  static Future<Map<String, dynamic>> fetchallCategories( {required Map<dynamic, dynamic> parameter}) async {
    try {
      var data = await ApiBaseHelper().postAPICall(allCategoriesApi, parameter);

      return data;
    } on Exception catch (e) {
      throw ApiException('Something went wrong');
    }
  }
}
