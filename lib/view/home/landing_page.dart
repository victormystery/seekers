import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:seeker_ng/service/push_notification_service.dart';
import 'package:seeker_ng/service/searchbar_with_dropdown_service.dart';
import 'package:seeker_ng/view/home/home.dart';
import 'package:seeker_ng/view/notification/push_notification_helper.dart';
import 'package:seeker_ng/view/tabs/saved_item_page.dart';
import 'package:seeker_ng/view/tabs/search/search_tab.dart';
import 'package:seeker_ng/view/tabs/settings/menu_page.dart';
import 'package:seeker_ng/view/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../tabs/orders/orders_page.dart';
import '../utils/others_helper.dart';
import 'bottom_nav.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<LandingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPusherBeams(context);
    setChatSellerId(null);
  }

  DateTime? currentBackPressTime;

  void onTabTapped(int index) {
    if (index == 3) {
      Provider.of<SearchBarWithDropdownService>(context, listen: false)
          .resetSearchParams();
      Provider.of<SearchBarWithDropdownService>(context, listen: false)
          .fetchService(context);
    }
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;
  //Bottom nav pages
  final List<Widget> _children = [
    const Homepage(),
    const OrdersPage(),
    const SavedItemPage(),
    const SearchTab(),
    const MenuPage(),
  ];

  //Notification alert
  //=================>
  initPusherBeams(BuildContext context) async {
    var pusherInstance =
        await Provider.of<PushNotificationService>(context, listen: false)
            .pusherInstance;

    if (pusherInstance == null) return;

    if (!kIsWeb) {
      await PusherBeams.instance
          .onMessageReceivedInTheForeground(_onMessageReceivedInTheForeground);
    }
    await _checkForInitialMessage(context);
    //init pusher instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    try {
      await PusherBeams.instance.addDeviceInterest('debug-buyer$userId');
    } catch (e) {}
  }

  Future<void> _checkForInitialMessage(BuildContext context) async {
    final initialMessage = await PusherBeams.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotificationHelper().notificationAlert(
          context, 'Initial Message Is:', initialMessage.toString());
    }
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    Map metaData = data["data"] is Map ? data["data"] as Map : {};
    if (metaData["type"] == "message" &&
        metaData["sender-id"] == chatSellerId) {
      return;
    }
    PushNotificationHelper().notificationAlert(
        context, data["title"].toString(), data["body"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
          onWillPop: () {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(seconds: 2)) {
              currentBackPressTime = now;
              OthersHelper().showToast("Press again to exit", Colors.black);
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: _children[_currentIndex]),
      // floatingActionButton: _currentIndex != 0 ? null : const ViewTypeIcon(),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
