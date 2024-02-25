import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/app_string_service.dart';
import 'package:seeker_ng/service/common_service.dart';
import 'package:seeker_ng/service/searchbar_with_dropdown_service.dart';
import 'package:seeker_ng/view/search/components/online_offline_dropdown.dart';
import 'package:seeker_ng/view/utils/constant_styles.dart';
import 'package:seeker_ng/view/utils/others_helper.dart';

import '../../../service/service_details_service.dart';
import '../../auth/signup/dropdowns/country_dropdown.dart';
import '../../auth/signup/dropdowns/state_dropdown.dart';
import '../../home/components/service_card.dart';
import '../../services/service_details_page.dart';
import '../../utils/constant_colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer? timer;
    ConstantColors cc = ConstantColors();
    TextEditingController searchController = TextEditingController();
    return Consumer<AppStringService>(
      builder: (context, asProvider, child) =>
          Consumer<SearchBarWithDropdownService>(
        builder: (context, provider, child) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              //Search bar and dropdown
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.01),
                                    spreadRadius: -2,
                                    blurRadius: 13,
                                    offset: const Offset(0, 13)),
                              ],
                              borderRadius: BorderRadius.circular(3)),
                          child: TextFormField(
                            controller: searchController,
                            autofocus: true,
                            onFieldSubmitted: (value) {
                              provider.fetchService(
                                context,
                                searchText: value,
                              );
                            },
                            onChanged: (value) {
                              // if (value.isNotEmpty) {
                              timer?.cancel();
                              timer = Timer(const Duration(seconds: 1), () {
                                provider.fetchService(
                                  context,
                                  searchText: value,
                                );
                              });
                              // }
                            },
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.search),
                                hintText: asProvider.getString("Search"),
                                hintStyle: TextStyle(
                                    color: cc.greyPrimary.withOpacity(.8)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 15)),
                          ))),
                ],
              ),

              sizedBoxCustom(20),

              //Country state
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CountryDropdown(
                      textWidth: MediaQuery.of(context).size.width / 3.6,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: StateDropdown(
                        textWidth: MediaQuery.of(context).size.width / 3.6,
                      ))
                ],
              ),

              //Area, online/offline
              sizedBoxCustom(15),
              Row(
                children: [
                  // const Expanded(
                  //   child: AreaDropdown(),
                  // ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  Expanded(
                      child: OnlineOfflineDropdown(
                    searchText: searchController.text,
                  ))
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              //Services
              provider.isLoading == false
                  ? provider.serviceMap.isNotEmpty
                      ? provider.serviceMap[0] != 'error'
                          ? Column(
                              children: [
                                for (int i = 0;
                                    i < provider.serviceMap.length;
                                    i++)
                                  Column(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const ServiceDetailsPage(),
                                            ),
                                          );
                                          Provider.of<ServiceDetailsService>(
                                                  context,
                                                  listen: false)
                                              .fetchServiceDetails(provider
                                                  .serviceMap[i]['serviceId']);
                                        },
                                        child: ServiceCard(
                                          cc: cc,
                                          imageLink: provider.serviceMap[i]
                                                  ['image'] ??
                                              placeHolderUrl,
                                          rating: twoDouble(
                                              provider.serviceMap[i]['rating']),
                                          title: provider.serviceMap[i]
                                              ['title'],
                                          sellerName: provider.serviceMap[i]
                                              ['sellerName'],
                                          price: provider.serviceMap[i]
                                              ['price'],
                                          buttonText: 'Book Now',
                                          width: double.infinity,
                                          marginRight: 0.0,
                                          pressed: () {
                                            provider.saveOrUnsave(
                                                provider.serviceMap[i]
                                                    ['serviceId'],
                                                provider.serviceMap[i]['title'],
                                                provider.serviceMap[i]['image'],
                                                provider.serviceMap[i]['price']
                                                    .round(),
                                                provider.serviceMap[i]
                                                    ['sellerName'],
                                                twoDouble(provider.serviceMap[i]
                                                    ['rating']),
                                                i,
                                                context,
                                                provider.serviceMap[i]
                                                    ['sellerId']);
                                          },
                                          isSaved: provider.serviceMap[i]
                                                      ['isSaved'] ==
                                                  true
                                              ? true
                                              : false,
                                          serviceId: provider.serviceMap[i]
                                              ['serviceId'],
                                          sellerId: provider.serviceMap[i]
                                              ['sellerId'],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    asProvider.getString("No result found"),
                                    style: TextStyle(color: cc.greyPrimary),
                                  ),
                                )
                              ],
                            )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Text(
                                asProvider.getString("No result found"),
                                style: TextStyle(color: cc.greyPrimary),
                              ),
                            )
                          ],
                        )
                  : OthersHelper().showLoading(cc.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
