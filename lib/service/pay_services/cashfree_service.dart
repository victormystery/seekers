import 'dart:convert';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/book_confirmation_service.dart';
import 'package:seeker_ng/service/booking_services/book_service.dart';
import 'package:seeker_ng/service/booking_services/personalization_service.dart';
import 'package:seeker_ng/service/jobs_service/job_request_service.dart';
import 'package:seeker_ng/service/order_details_service.dart';
import 'package:seeker_ng/service/payment_gateway_list_service.dart';
import 'package:seeker_ng/service/profile_service.dart';
import 'package:seeker_ng/service/wallet_service.dart';
import 'package:seeker_ng/view/utils/others_helper.dart';

import '../booking_services/place_order_service.dart';
import '../rtl_service.dart';

class CashfreeService {
  getTokenAndPay(BuildContext context,
      {bool isFromOrderExtraAccept = false,
      bool isFromWalletDeposite = false,
      bool isFromHireJob = false}) async {
    //========>

    String amount;

    String name;
    String phone;
    String email;
    String orderId;
    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .name ??
        'test';
    phone = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .phone ??
        '111111111';
    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .email ??
        'test@test.com';

    if (isFromOrderExtraAccept == true) {
      Provider.of<PlaceOrderService>(context, listen: false).setLoadingTrue();
      amount = Provider.of<OrderDetailsService>(context, listen: false)
          .selectedExtraPrice;

      orderId = Provider.of<OrderDetailsService>(context, listen: false)
          .selectedExtraId
          .toString();
    } else if (isFromWalletDeposite) {
      amount = Provider.of<WalletService>(context, listen: false).amountToAdd;

      orderId = 'wallet' +
          Provider.of<WalletService>(context, listen: false)
              .walletHistoryId
              .toString();
    } else if (isFromHireJob) {
      amount = Provider.of<JobRequestService>(context, listen: false)
          .selectedJobPrice;

      orderId = "$name$amount";
    } else {
      var bcProvider =
          Provider.of<BookConfirmationService>(context, listen: false);
      var pProvider =
          Provider.of<PersonalizationService>(context, listen: false);
      var bookProvider = Provider.of<BookService>(context, listen: false);
      orderId = Provider.of<PlaceOrderService>(context, listen: false).orderId;

      name = bookProvider.name ?? '';
      phone = bookProvider.phone ?? '';
      email = bookProvider.email ?? '';

      if (pProvider.isOnline == 0) {
        amount = bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2);
      } else {
        amount = bcProvider.totalPriceOnlineServiceAfterAllCalculation
            .toStringAsFixed(2);
      }
    }

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      // "Accept": "application/json",
      'x-client-id':
          Provider.of<PaymentGatewayListService>(context, listen: false)
              .publicKey
              .toString(),
      'x-client-secret':
          Provider.of<PaymentGatewayListService>(context, listen: false)
              .secretKey
              .toString(),
      "Content-Type": "application/json"
    };

    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;
    var data = jsonEncode({
      'orderId': orderId,
      'orderAmount': amount,
      'orderCurrency': currencyCode
    });

    var response = await http.post(
      Uri.parse(
          'https://test.cashfree.com/api/v2/cftoken/order'), // change url to https://api.cashfree.com/api/v2/cftoken/order when in production
      body: data,
      headers: header,
    );
    print(response.body);

    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    if (jsonDecode(response.body)['status'] == "OK") {
      cashFreePay(
          jsonDecode(response.body)['cftoken'],
          orderId,
          currencyCode,
          context,
          amount,
          name,
          phone,
          email,
          isFromOrderExtraAccept,
          isFromWalletDeposite,
          isFromHireJob);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }
    // if()
  }

  cashFreePay(
      token,
      orderId,
      orderCurrency,
      BuildContext context,
      amount,
      name,
      phone,
      email,
      isFromOrderExtraAccept,
      isFromWalletDeposite,
      isFromHireJob) {
    //Replace with actual values
    //has to be unique every time
    String stage = "TEST"; // PROD when in production mode// TEST when in test

    String tokenData = token; //generate token data from server

    String appId = "94527832f47d6e74fa6ca5e3c72549";

    String notifyUrl = "";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": amount,
      "customerName": name,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": phone,
      "customerEmail": email,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };

    CashfreePGSDK.doPayment(
      inputParams,
    ).then((value) {
      print('cashfree payment result $value');
      if (value != null) {
        if (value['txStatus'] == "SUCCESS") {
          print('Cashfree Payment successfull. Do something here');

          if (isFromOrderExtraAccept == true) {
            Provider.of<OrderDetailsService>(context, listen: false)
                .acceptOrderExtra(context);
          } else if (isFromWalletDeposite) {
            Provider.of<WalletService>(context, listen: false)
                .makeDepositeToWalletSuccess(context);
          } else if (isFromHireJob) {
            Provider.of<JobRequestService>(context, listen: false)
                .goToJobSuccessPage(context);
          } else {
            Provider.of<PlaceOrderService>(context, listen: false)
                .makePaymentSuccess(context);
          }
        } else {
          Provider.of<PlaceOrderService>(context, listen: false)
              .doNext(context, 'failed', paymentFailed: true);
        }
      }
    });
  }
}
