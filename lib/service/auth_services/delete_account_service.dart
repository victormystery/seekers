// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/helper/extension/context_extension.dart';
import 'package:seeker_ng/service/common_service.dart';
import 'package:seeker_ng/service/profile_service.dart';
import 'package:seeker_ng/view/utils/others_helper.dart';
import 'package:seeker_ng/view/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountService with ChangeNotifier {
  bool isloading = false;
  var deactivateReasonDropdownList = ['Vacation', 'Personal reason'];
  var deactivateReasonDropdownIndexList = ['Vacation', 'Vacation'];
  var selecteddeactivateReason = 'Vacation';
  var selecteddeactivateReasonId = 'Vacation';

  setdeactivateReasonValue(value) {
    selecteddeactivateReason = value;
    notifyListeners();
  }

  setSelecteddeactivateReasonId(value) {
    selecteddeactivateReasonId = value;
    notifyListeners();
  }

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  deleteAccount(BuildContext context, password, description) async {
    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      setLoadingTrue();
      if (baseApi.contains('bytesed.com/laravel/qixer')) {
        await Future.delayed(const Duration(seconds: 1));
        OthersHelper()
            .showToast('This feature is turned off in test mode', Colors.black);
        setLoadingFalse();
        return;
      }
      var response = await http.post(
        Uri.parse(
            '$baseApi/account-delete?reason=$selecteddeactivateReasonId&description=$description&password=$password'),
        headers: header,
      );
      if (response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            OthersHelper().showToast(data['message'], Colors.black);
          }
        } catch (e) {}
        var appleId = sPref.getString("appleId");
        var appleUserToken = sPref.getString("userToken");

        // Navigator.pushAndRemoveUntil<dynamic>(
        //   context,

        //     builder: (BuildContext context) => const LoginPage(
        //       hasBackButton: false,
        //     ),
        //   ),
        //   (route) => false,
        // );

        // clear profile data =====>
        Provider.of<ProfileService>(context, listen: false)
            .setEverythingToDefault();

        clear();
        context.popFalse;
        setLoadingFalse();
      } else {
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            OthersHelper().showToast(data['message'], Colors.black);
            setLoadingFalse();
            return;
          }
        } catch (e) {}
        print(response.body);
        OthersHelper().showToast('Something went wrong', Colors.black);
        setLoadingFalse();
      }
    }
  }

  //clear saved email, pass and token
  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
