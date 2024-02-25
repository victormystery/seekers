import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:seeker_ng/model/service_details_model.dart';
import 'package:seeker_ng/service/common_service.dart';
import 'package:seeker_ng/view/utils/others_helper.dart';

class ServiceDetailsService with ChangeNotifier {
  var serviceAllDetails;

  var sellerId;

  bool isloading = false;

  // List reviewList = [];

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  fetchServiceDetails(serviceId) async {
    setLoadingTrue();
    var connection = await checkConnection();
    if (connection) {
      // reviewList = [];
      //internet connection is on
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
      };

      print('$baseApi/service-details/$serviceId');

      var response = await http.get(
          Uri.parse('$baseApi/service-details/$serviceId'),
          headers: header);

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        // serviceAllDetails =
        //     ServiceDetailsModel.fromJson(jsonDecode(response.body));
        var data = ServiceDetailsModel.fromJson(jsonDecode(response.body));

        serviceAllDetails = data;
        sellerId = jsonDecode(response.body)['service_details']
            ['seller_for_mobile']['id'];
        // for (int i = 0; i < data.serviceReviews.length; i++) {
        //   reviewList.add({'rating': data.serviceReviews[i].rating, 'message':data.serviceReviews[i].message,});
        // }
        notifyListeners();
        setLoadingFalse();
      } else {
        serviceAllDetails = 'error';

        print(serviceAllDetails);
        setLoadingFalse();
        OthersHelper().showToast('Something went wrong', Colors.black);
        notifyListeners();
      }
    }
  }
}
