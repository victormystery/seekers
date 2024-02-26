import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seeker_ng/service/all_services_service.dart';
import 'package:seeker_ng/service/app_string_service.dart';
import 'package:seeker_ng/service/auth_services/change_pass_service.dart';
import 'package:seeker_ng/service/auth_services/delete_account_service.dart';
import 'package:seeker_ng/service/auth_services/email_verify_service.dart';
import 'package:seeker_ng/service/auth_services/facebook_login_service.dart';
import 'package:seeker_ng/service/auth_services/google_sign_service.dart';
import 'package:seeker_ng/service/auth_services/login_service.dart';
import 'package:seeker_ng/service/auth_services/logout_service.dart';
import 'package:seeker_ng/service/auth_services/reset_password_service.dart';
import 'package:seeker_ng/service/book_confirmation_service.dart';
import 'package:seeker_ng/service/book_steps_service.dart';
import 'package:seeker_ng/service/booking_services/book_service.dart';
import 'package:seeker_ng/service/booking_services/coupon_service.dart';
import 'package:seeker_ng/service/booking_services/personalization_service.dart';
import 'package:seeker_ng/service/booking_services/place_order_service.dart';
import 'package:seeker_ng/service/booking_services/shedule_service.dart';
import 'package:seeker_ng/service/country_states_service.dart';
import 'package:seeker_ng/service/dropdowns_services/area_dropdown_service.dart';
import 'package:seeker_ng/service/dropdowns_services/country_dropdown_service.dart';
import 'package:seeker_ng/service/dropdowns_services/state_dropdown_services.dart';
import 'package:seeker_ng/service/jobs_service/create_job_service.dart';
import 'package:seeker_ng/service/home_services/category_service.dart';
import 'package:seeker_ng/service/home_services/recent_services_service.dart';
import 'package:seeker_ng/service/home_services/slider_service.dart';
import 'package:seeker_ng/service/home_services/top_all_services_service.dart';
import 'package:seeker_ng/service/home_services/top_rated_services_service.dart';
import 'package:seeker_ng/service/jobs_service/edit_job_country_states_service.dart';
import 'package:seeker_ng/service/jobs_service/edit_job_service.dart';
import 'package:seeker_ng/service/jobs_service/job_conversation_service.dart';
import 'package:seeker_ng/service/jobs_service/job_request_service.dart';
import 'package:seeker_ng/service/jobs_service/my_jobs_service.dart';
import 'package:seeker_ng/service/jobs_service/recent_jobs_service.dart';
import 'package:seeker_ng/service/leave_feedback_service.dart';
import 'package:seeker_ng/service/live_chat/chat_list_service.dart';
import 'package:seeker_ng/service/live_chat/chat_message_service.dart';
import 'package:seeker_ng/service/my_orders_service.dart';
import 'package:seeker_ng/service/order_details_service.dart';
import 'package:seeker_ng/service/orders_service.dart';
import 'package:seeker_ng/service/pay_services/bank_transfer_service.dart';
import 'package:seeker_ng/service/pay_services/stripe_service.dart';
import 'package:seeker_ng/service/payment_gateway_list_service.dart';
import 'package:seeker_ng/service/permissions_service.dart';
import 'package:seeker_ng/service/profile_edit_service.dart';
import 'package:seeker_ng/service/profile_service.dart';
import 'package:seeker_ng/service/push_notification_service.dart';
import 'package:seeker_ng/service/report_services/report_message_service.dart';
import 'package:seeker_ng/service/report_services/report_service.dart';
import 'package:seeker_ng/service/rtl_service.dart';
import 'package:seeker_ng/service/saved_items_service.dart';
import 'package:seeker_ng/service/seller_all_services_service.dart';
import 'package:seeker_ng/service/searchbar_with_dropdown_service.dart';
import 'package:seeker_ng/service/service_details_service.dart';
import 'package:seeker_ng/service/auth_services/signup_service.dart';
import 'package:seeker_ng/service/serviceby_category_service.dart';
import 'package:seeker_ng/service/support_ticket/create_ticket_service.dart';
import 'package:seeker_ng/service/support_ticket/support_messages_service.dart';
import 'package:seeker_ng/service/support_ticket/support_ticket_service.dart';
import 'package:seeker_ng/service/wallet_service.dart';
import 'package:seeker_ng/themes/default_themes.dart';
import 'package:seeker_ng/view/intro/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('icon'),
    ),
    // onDidReceiveBackgroundNotificationResponse: (_) {},
    // onDidReceiveNotificationResponse: (_) {},
  );
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidImplementation?.requestPermission();

  runApp(const MyApp());

//get user id, so that we can clear everything cached by provider when user logs out and logs in again
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getInt('userId');
}

int? userId;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
      key: ObjectKey(userId),
      providers: [
        ChangeNotifierProvider(create: (_) => CountryStatesService()),
        ChangeNotifierProvider(create: (_) => SignupService()),
        ChangeNotifierProvider(create: (_) => BookConfirmationService()),
        ChangeNotifierProvider(create: (_) => BookStepsService()),
        ChangeNotifierProvider(create: (_) => AllServicesService()),
        ChangeNotifierProvider(create: (_) => LoginService()),
        ChangeNotifierProvider(create: (_) => ResetPasswordService()),
        ChangeNotifierProvider(create: (_) => LogoutService()),
        ChangeNotifierProvider(create: (_) => ChangePassService()),
        ChangeNotifierProvider(create: (_) => ProfileService()),
        ChangeNotifierProvider(create: (_) => SliderService()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => TopRatedServicesSerivce()),
        ChangeNotifierProvider(create: (_) => ProfileEditService()),
        ChangeNotifierProvider(create: (_) => RecentServicesService()),
        ChangeNotifierProvider(create: (_) => SavedItemService()),
        ChangeNotifierProvider(create: (_) => ServiceDetailsService()),
        ChangeNotifierProvider(create: (_) => LeaveFeedbackService()),
        ChangeNotifierProvider(create: (_) => GoogleSignInService()),
        ChangeNotifierProvider(create: (_) => StripeService()),
        ChangeNotifierProvider(create: (_) => BankTransferService()),
        ChangeNotifierProvider(create: (_) => ServiceByCategoryService()),
        ChangeNotifierProvider(create: (_) => PersonalizationService()),
        ChangeNotifierProvider(create: (_) => BookService()),
        ChangeNotifierProvider(create: (_) => BookService()),
        ChangeNotifierProvider(create: (_) => SheduleService()),
        ChangeNotifierProvider(create: (_) => CouponService()),
        ChangeNotifierProvider(create: (_) => SearchBarWithDropdownService()),
        ChangeNotifierProvider(create: (_) => MyOrdersService()),
        ChangeNotifierProvider(create: (_) => PlaceOrderService()),
        ChangeNotifierProvider(create: (_) => FacebookLoginService()),
        ChangeNotifierProvider(create: (_) => SupportTicketService()),
        ChangeNotifierProvider(create: (_) => SupportMessagesService()),
        ChangeNotifierProvider(create: (_) => CreateTicketService()),
        ChangeNotifierProvider(create: (_) => EmailVerifyService()),
        ChangeNotifierProvider(create: (_) => OrderDetailsService()),
        ChangeNotifierProvider(create: (_) => RtlService()),
        ChangeNotifierProvider(create: (_) => TopAllServicesService()),
        ChangeNotifierProvider(create: (_) => PaymentGatewayListService()),
        ChangeNotifierProvider(create: (_) => AppStringService()),
        ChangeNotifierProvider(create: (_) => ChatListService()),
        ChangeNotifierProvider(create: (_) => ChatMessagesService()),
        ChangeNotifierProvider(create: (_) => MyJobsService()),
        ChangeNotifierProvider(create: (_) => CreateJobService()),
        ChangeNotifierProvider(create: (_) => EditJobService()),
        ChangeNotifierProvider(create: (_) => JobRequestService()),
        ChangeNotifierProvider(create: (_) => JobConversationService()),
        ChangeNotifierProvider(create: (_) => EditJobCountryStatesService()),
        ChangeNotifierProvider(create: (_) => OrdersService()),
        ChangeNotifierProvider(create: (_) => WalletService()),
        ChangeNotifierProvider(create: (_) => SellerAllServicesService()),
        ChangeNotifierProvider(create: (_) => PushNotificationService()),
        ChangeNotifierProvider(create: (_) => ReportService()),
        ChangeNotifierProvider(create: (_) => ReportMessagesService()),
        ChangeNotifierProvider(create: (_) => RecentJobsService()),
        ChangeNotifierProvider(create: (_) => PermissionsService()),
        ChangeNotifierProvider(create: (_) => CountryDropdownService()),
        ChangeNotifierProvider(create: (_) => StateDropdownService()),
        ChangeNotifierProvider(create: (_) => AreaDropdownService()),
        ChangeNotifierProvider(create: (_) => DeleteAccountService()),
      ],
      child: Consumer<RtlService>(
        builder: (context, rtlProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SEEKERS.NG',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale(rtlProvider.langSlug.substring(0, 2)),
              const Locale('en', "US")
            ],
            builder: (context, rtlchild) {
              return Consumer<RtlService>(
                builder: (context, rtlP, child) => Directionality(
                  textDirection: rtlP.direction == 'ltr'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: rtlchild!,
                ),
              );
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: DefaultThemes().appBarTheme(context),
            ),
            home: child,
          );
        },
        child: const SplashScreen(),
      ),
    );
  }
}
