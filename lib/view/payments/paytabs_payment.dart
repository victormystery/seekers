// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/booking_services/place_order_service.dart';
import 'package:seeker_ng/service/jobs_service/job_request_service.dart';
import 'package:seeker_ng/service/order_details_service.dart';
import 'package:seeker_ng/service/payment_gateway_list_service.dart';
import 'package:seeker_ng/service/wallet_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../service/rtl_service.dart';
import '../utils/common_helper.dart';

class PayTabsPayment extends StatelessWidget {
  PayTabsPayment(
      {Key? key,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email,
      required this.orderId,
      required this.isFromOrderExtraAccept,
      required this.isFromWalletDeposite,
      required this.isFromHireJob})
      : super(key: key);

  final amount;
  final name;
  final phone;
  final email;
  final isFromHireJob;

  final orderId;
  final isFromOrderExtraAccept;
  final isFromWalletDeposite;

  String? url;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(microseconds: 600), () {
      Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();
    });

    return Scaffold(
      appBar: CommonHelper().appbarCommon('PayTabs', context, () {
        Provider.of<PlaceOrderService>(context, listen: false)
            .doNext(context, 'failed', paymentFailed: true);
      }),
      body: WillPopScope(
        onWillPop: () async {
          await Provider.of<PlaceOrderService>(context, listen: false)
              .doNext(context, 'failed', paymentFailed: true);
          return false;
        },
        child: FutureBuilder(
            future: waitForIt(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return const Center(
                  child: Text('Loding failed.'),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text('Loding failed.'),
                );
              }
              return WebView(
                // onWebViewCreated: ((controller) {
                //   _controller = controller;
                // }),
                onWebResourceError: (error) {
                  Provider.of<PlaceOrderService>(context, listen: false)
                      .doNext(context, 'failed', paymentFailed: true);
                },
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,

                onPageFinished: (value) async {},
                onPageStarted: (value) async {
                  if (!value.contains('result')) {
                    return;
                  }
                  bool paySuccess = await verifyPayment(value);

                  if (paySuccess) {
                    if (isFromOrderExtraAccept == true) {
                      await Provider.of<OrderDetailsService>(context,
                              listen: false)
                          .acceptOrderExtra(context);
                    } else if (isFromWalletDeposite) {
                      await Provider.of<WalletService>(context, listen: false)
                          .makeDepositeToWalletSuccess(context);
                    } else if (isFromHireJob) {
                      Provider.of<JobRequestService>(context, listen: false)
                          .goToJobSuccessPage(context);
                    } else {
                      await Provider.of<PlaceOrderService>(context,
                              listen: false)
                          .makePaymentSuccess(context);
                    }
                    return;
                  }
                  await Provider.of<PlaceOrderService>(context, listen: false)
                      .doNext(context, 'failed', paymentFailed: true);
                },
                navigationDelegate: (navRequest) async {
                  return NavigationDecision.navigate;
                },
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    // String profileId =
    //     Provider.of<PaymentGatewayListService>(context, listen: false)
    //         .paytabProfileId;
    String secretKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .secretKey;
    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;

    print('here');
    final url = Uri.parse('https://secure-global.paytabs.com/payment/request');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": secretKey,
      // Above is API server key for the Midtrans account, encoded to base64
    };

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "profile_id": 96698,
          "tran_type": "sale",
          "tran_class": "ecom",
          "cart_id": orderId.toString(),
          "cart_description": "Qixer payment",
          "cart_currency": currencyCode,
          "cart_amount": amount,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['redirect_url'];
      print(this.url);
      return;
    }

    return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}
