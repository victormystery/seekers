import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/app_string_service.dart';
import 'package:seeker_ng/service/order_details_service.dart';
import 'package:seeker_ng/view/booking/booking_helper.dart';
import 'package:seeker_ng/view/utils/common_helper.dart';

class SellerDetails extends StatelessWidget {
  const SellerDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, asProvider, child) => Consumer<OrderDetailsService>(
        builder: (context, provider, child) => Column(
          children: [
            provider.orderDetails.sellerDetails != null
                ? Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().titleCommon(
                              asProvider.getString('Seller Details')),
                          const SizedBox(
                            height: 25,
                          ),
                          //Service row

                          Container(
                            child: BookingHelper().bRow(
                                'null',
                                asProvider.getString('Name'),
                                provider.orderDetails.sellerDetails.name),
                          ),

                          Container(
                            child: BookingHelper().bRow(
                                'null',
                                asProvider.getString('Email'),
                                provider.orderDetails.sellerDetails.email),
                          ),

                          Container(
                            child: BookingHelper().bRow(
                                'null',
                                asProvider.getString('Phone'),
                                provider.orderDetails.sellerDetails.phone),
                          ),
                          provider.orderDetails.isOrderOnline == 0
                              ? Container(
                                  child: BookingHelper().bRow(
                                      'null',
                                      asProvider.getString('Post code'),
                                      provider.orderDetails.sellerDetails
                                              .postCode ??
                                          ''),
                                )
                              : Container(),
                          provider.orderDetails.isOrderOnline == 0
                              ? Container(
                                  child: BookingHelper().bRow(
                                      'null',
                                      asProvider.getString('Address'),
                                      provider.orderDetails.sellerDetails
                                              .address ??
                                          "",
                                      lastBorder: false),
                                )
                              : Container(),
                        ]),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
