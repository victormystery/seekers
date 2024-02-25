// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/model/wallet_history_model.dart';
import 'package:seeker_ng/service/booking_services/place_order_service.dart';
import 'package:seeker_ng/service/common_service.dart';
import 'package:seeker_ng/service/jobs_service/job_request_service.dart';
import 'package:seeker_ng/service/order_details_service.dart';
import 'package:seeker_ng/service/payment_gateway_list_service.dart';
import 'package:seeker_ng/view/home/landing_page.dart';
import 'package:seeker_ng/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:seeker_ng/view/wallet/wallet_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService with ChangeNotifier {
  var walletHistory;
  var walletBalance = '\$0.0';

  var walletHistoryId;

  bool isloading = false;
  bool hasWalletHistory = true;

  setLoadingStatus(bool status) {
    isloading = status;
    notifyListeners();
  }

  var amountToAdd;

  setAmount(v) {
    amountToAdd = v;
    notifyListeners();
  }

  // Fetch subscription history
  fetchWalletHistory(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(Uri.parse('$baseApi/user/wallet/history'),
        headers: header);

    final decodedData = jsonDecode(response.body);

    print('wallet history response ${response.body}');

    if (response.statusCode == 200 && decodedData['history'].isNotEmpty) {
      final data = WalletHistoryModel.fromJson(jsonDecode(response.body));
      walletHistory = data.history;
      notifyListeners();
    } else {
      print('Error fetching wallet history' + response.body);

      hasWalletHistory = false;
      notifyListeners();

      Future.delayed(const Duration(seconds: 1), () {
        hasWalletHistory = true;
      });
    }
  }

  // Fetch wallet balance
  Future<bool> fetchWalletBalance(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(Uri.parse('$baseApi/user/wallet/balance'),
        headers: header);

    print('wallet balance response ${response.body}');

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      walletBalance = decodedData['balance'];
      notifyListeners();

      return true;
    } else {
      print('Error fetching wallet balance' + response.body);

      return false;
    }
  }

  //============>
  //=========>

  Future<bool> createDepositeRequest(BuildContext context,
      {imagePath, bool isManualOrCod = false}) async {
    //get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var connection = await checkConnection();
    if (!connection) return false;
    //if connection is ok

    Provider.of<PlaceOrderService>(context, listen: false).setLoadingTrue();

    var selectedPayment =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .selectedMethodName ??
            'cash_on_delivery';

    FormData formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    if (imagePath != null) {
      formData = FormData.fromMap({
        'amount': amountToAdd,
        'payment_gateway': selectedPayment,
        'manual_payment_image': await MultipartFile.fromFile(imagePath,
            filename: 'bankTransfer.jpg'),
      });
    } else {
      formData = FormData.fromMap({
        'amount': amountToAdd,
        'payment_gateway': selectedPayment,
      });
    }

    var response = await dio.post(
      '$baseApi/user/wallet/deposit',
      data: formData,
      options: Options(
        validateStatus: (status) {
          return true;
        },
      ),
    );

    print(response.data);
    print(response.statusCode);

    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    if (response.statusCode == 200) {
      walletHistoryId = response.data['deposit_info']['wallet_history_id'];

      if (isManualOrCod == true) {
        print('manual or code ran');
        inSuccess(context);
      }

      notifyListeners();

      return true;
    } else {
      print('error depositing to wallet ${response.data}');

      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }

  Future<bool> makeDepositeToWalletSuccess(BuildContext context,
      {shouldPop = true}) async {
    //make payment success

    var connection = await checkConnection();
    if (!connection) return false;
    //internet connection is on
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    print('wallet history id $walletHistoryId');
    var data = jsonEncode({'wallet_history_id': walletHistoryId});

    var response = await http.post(
        Uri.parse('$baseApi/user/wallet/deposit/payment-status'),
        headers: header,
        body: data);

    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      inSuccess(context, shouldPop: shouldPop);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }

    return true;
  }

  // =========>
  inSuccess(BuildContext context, {shouldPop = true}) async {
    setAmount(null);

    if (shouldPop) {
      OthersHelper().showToast('Wallet deposit success', Colors.black);
      await fetchWalletBalance(context);
      fetchWalletHistory(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LandingPage()),
          (Route<dynamic> route) => false);

      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const WalletPage(),
        ),
      );
    }
  }

  // =================>
  //===============>
  // Deduct money from wallet
  Future<bool> deductFromWallet(BuildContext context,
      {required amount,
      isFromOrderExtraAccept = false,
      isFromHireJob = false}) async {
    var connection = await checkConnection();
    if (!connection) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    print('amount is $amount');

    Provider.of<PlaceOrderService>(context, listen: false).setLoadingTrue();

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data = jsonEncode({'amount': amount});

    var response = await http.post(Uri.parse('$baseApi/user/wallet/deduct'),
        headers: header, body: data);
    print("deductFromWallet");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      //
      if (isFromOrderExtraAccept == true) {
        await Provider.of<OrderDetailsService>(context, listen: false)
            .acceptOrderExtra(context);

        Provider.of<PlaceOrderService>(context, listen: false)
            .setLoadingFalse();

        return true;
      } else if (isFromHireJob) {
        print('is from hire job');
        Provider.of<PlaceOrderService>(context, listen: false)
            .setLoadingFalse();

        Provider.of<JobRequestService>(context, listen: false)
            .createHireJobRequest(context, isManualOrCod: true)
            .then((value) async {
          if (value == false) {
            setAmount(amount);
            await createDepositeRequest(context, imagePath: null);
            makeDepositeToWalletSuccess(context, shouldPop: false);
          }
        });
      } else {
        Provider.of<PlaceOrderService>(context, listen: false)
            .makePaymentSuccess(context);
        Provider.of<PlaceOrderService>(context, listen: false)
            .setLoadingFalse();
      }
// go to success page

      return true;
    } else {
      if (isFromOrderExtraAccept != true && !isFromHireJob) {
        Provider.of<PlaceOrderService>(context, listen: false)
            .doNext(context, "Payment failed", paymentFailed: true);
      }
      Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

      print('Error deposite to wallet' + response.body);
      return false;
    }
  }

  //=====================>
  //================>

  Future<bool> validate(BuildContext context, isFromDepositeToWallet) async {
    if (isFromDepositeToWallet && amountToAdd == null) {
      OthersHelper().showToast('You must enter an amount', Colors.black);
      return false;
    }
    if (isFromDepositeToWallet && double.tryParse(amountToAdd) == null) {
      // user entered non integer value
      OthersHelper().showToast('Please enter a valid amount', Colors.black);
      return false;
    }
    return true;
  }
}
