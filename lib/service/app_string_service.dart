import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seeker_ng/service/common_service.dart';
import 'package:seeker_ng/view/utils/app_strings.dart';
import 'package:seeker_ng/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppStringService with ChangeNotifier {
  bool isloading = false;

  var tStrings;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  fetchTranslatedStrings(BuildContext context, {bool doNotLoad = false}) async {
    if (tStrings != null) {
      //if already loaded. no need to load again
      return;
    }

    var connection = await checkConnection();
    if (connection) {
      //internet connection is on
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      if (doNotLoad) {
        final strings = prefs.getString('translated_string');
        tStrings = jsonDecode(strings ?? 'null');
        return;
      }
      setLoadingTrue();

      var data = jsonEncode({
        'strings': jsonEncode(appStrings),
      });

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.post(Uri.parse('$baseApi/translate-string'),
          headers: header, body: data);

      if (response.statusCode == 201) {
        tStrings = jsonDecode(response.body)['strings'];
        prefs.setString('translated_string', jsonEncode(tStrings));
        notifyListeners();
      } else {
        print('error fetching translations ' + response.body);
      }
    }
  }

  getString(String staticString) {
    if (tStrings == null) {
      return staticString;
    }
    if (tStrings.containsKey(staticString)) {
      return tStrings[staticString];
    } else {
      return staticString;
    }
  }
}
