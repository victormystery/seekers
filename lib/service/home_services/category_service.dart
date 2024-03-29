import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:seeker_ng/model/categoryModel.dart';
import 'package:seeker_ng/service/common_service.dart';
import 'package:seeker_ng/view/utils/others_helper.dart';

class CategoryService with ChangeNotifier {
  var categories;

  var categoriesDropdownList = [];

  fetchCategory() async {
    if (categories == null) {
      var connection = await checkConnection();
      if (connection) {
        var response = await http.get(Uri.parse('$baseApi/category'));

        if (response.statusCode == 201) {
          categories = CategoryModel.fromJson(jsonDecode(response.body));

          categoriesDropdownList = categories.category;

          notifyListeners();
        } else {
          //Something went wrong
          categories == 'error';
        }
      }
    } else {
      //already loaded from api
    }
  }
}
