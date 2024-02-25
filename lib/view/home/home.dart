import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/app_string_service.dart';
import 'package:seeker_ng/service/common_service.dart';
import 'package:seeker_ng/service/home_services/slider_service.dart';
import 'package:seeker_ng/view/home/categories/all_categories_page.dart';
import 'package:seeker_ng/view/home/components/categories.dart';
import 'package:seeker_ng/view/home/components/recent_jobs.dart';
import 'package:seeker_ng/view/home/components/recent_services.dart';
import 'package:seeker_ng/view/search/search_bar_page_with_dropdown.dart';
import 'package:seeker_ng/view/home/components/slider_home.dart';
import 'package:seeker_ng/view/home/components/top_rated_services.dart';
import 'package:seeker_ng/view/home/homepage_helper.dart';
import 'package:seeker_ng/view/utils/common_helper.dart';
import 'package:seeker_ng/view/utils/constant_colors.dart';
import 'package:seeker_ng/view/utils/responsive.dart';

import '../../service/searchbar_with_dropdown_service.dart';
import '../utils/constant_styles.dart';
import 'components/home_app_bar.dart';
import 'components/section_title.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    setChatSellerId(null);
    runAtHome(context);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
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
            child: Consumer<AppStringService>(
              builder: (context, asProvider, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //name and profile image
                    HomeAppBar(cc: cc),

                    //Search bar ========>
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: InkWell(
                          onTap: () {
                            Provider.of<SearchBarWithDropdownService>(context,
                                    listen: false)
                                .resetSearchParams();
                            Provider.of<SearchBarWithDropdownService>(context,
                                    listen: false)
                                .fetchService(context);
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: SearchBarPageWithDropdown(
                                      cc: cc,
                                    )));
                          },
                          child:
                              HomepageHelper().searchbar(asProvider, context)),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    CommonHelper().dividerCommon(),
                    const SizedBox(
                      height: 25,
                    ),

                    //Slider
                    Consumer<SliderService>(
                        builder: (context, provider, child) => provider
                                .sliderImageList.isNotEmpty
                            ? SliderHome(
                                cc: cc,
                                sliderDetailsList: provider.sliderDetailsList,
                                sliderImageList: provider.sliderImageList,
                              )
                            : Container()),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //see all ============>
                          const SizedBox(
                            height: 25,
                          ),

                          SectionTitle(
                            cc: cc,
                            title: asProvider.getString('Browse categories'),
                            pressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const AllCategoriesPage(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //Categories =============>
                          Categories(
                            cc: cc,
                            asProvider: asProvider,
                          ),

                          //Top rated sellers ========>

                          TopRatedServices(
                            cc: cc,
                            asProvider: asProvider,
                          ),

                          //Recent service ========>

                          RecentServices(
                            cc: cc,
                            asProvider: asProvider,
                          ),

                          //Discount images
                          const RecentJobs(),

                          sizedBoxCustom(30)
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
