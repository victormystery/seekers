import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/app_string_service.dart';
import 'package:seeker_ng/view/search/components/search_bar.dart' as sb;
import 'package:seeker_ng/view/utils/common_helper.dart';
import 'package:seeker_ng/view/utils/constant_colors.dart';
import 'package:seeker_ng/view/utils/constant_styles.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    ValueNotifier<bool> viewMap = ValueNotifier(false);

    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: physicsCommon,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenPadding),
                clipBehavior: Clip.none,
                child: Consumer<AppStringService>(
                  builder: (context, asProvider, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        CommonHelper().titleCommon(
                            asProvider.getString('Search services')),
                        sizedBox20(),
                        ValueListenableBuilder<bool>(
                            valueListenable: viewMap,
                            builder: (context, map, _) => const sb.SearchBar()),
                      ]),
                ),
              ),
            ),
          )),
    );
  }
}
