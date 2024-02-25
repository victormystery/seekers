import 'package:flutter/material.dart';
import 'package:seeker_ng/view/search/components/search_bar.dart' as sb;
import 'package:seeker_ng/view/utils/common_helper.dart';
import 'package:seeker_ng/view/utils/responsive.dart';

import '../utils/constant_colors.dart';

class SearchBarPageWithDropdown extends StatelessWidget {
  SearchBarPageWithDropdown({
    Key? key,
    required this.cc,
    this.isHomePage = false,
  }) : super(key: key);

  final bool isHomePage;

  final ConstantColors cc;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon(
        lnProvider.getString('Search'),
        context,
        () {
          Navigator.pop(context);
        },
      ),
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonHelper().dividerCommon(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                margin: const EdgeInsets.only(top: 25),
                child: const sb.SearchBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
