
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/helper/extension/context_extension.dart';
import 'package:seeker_ng/service/app_string_service.dart';
import 'package:seeker_ng/service/auth_services/google_sign_service.dart';
import 'package:seeker_ng/service/auth_services/login_service.dart';
import 'package:seeker_ng/view/auth/login/login_helper.dart';
import 'package:seeker_ng/view/auth/reset_password/reset_pass_email_page.dart';
import 'package:seeker_ng/view/auth/signup/signup.dart';
import 'package:seeker_ng/view/utils/common_helper.dart';
import 'package:seeker_ng/view/utils/constant_colors.dart';
import 'package:seeker_ng/view/utils/custom_input.dart';
import 'package:seeker_ng/view/utils/responsive.dart';
import '../../../service/auth_services/facebook_login_service.dart';
import '../../utils/constant_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.hasBackButton = true}) : super(key: key);

  final hasBackButton;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: physicsCommon,
        padding: EdgeInsets.zero,
        child: Consumer<AppStringService>(
          builder: (context, asProvider, child) => Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 230.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/login-slider.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () {
                        debugPrint("Pressed back".toString());
                        context.popFalse;
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 33,
                      ),

                      CommonHelper().titleCommon(
                          asProvider.getString('Welcome back! Login')),

                      const SizedBox(
                        height: 33,
                      ),

                      //Name ============>
                      CommonHelper().labelCommon(asProvider.getString("Email")),

                      CustomInput(
                        controller: emailController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        hintText: asProvider.getString("Email"),
                        icon: 'assets/icons/user.png',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      //password ===========>
                      CommonHelper()
                          .labelCommon(asProvider.getString("Password")),

                      Container(
                          margin: const EdgeInsets.only(bottom: 19),
                          decoration: BoxDecoration(
                              // color: const Color(0xfff2f2f2),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            obscureText: !_passwordVisible,
                            style: const TextStyle(fontSize: 14),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return lnProvider
                                    .getString('Please enter your password');
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 22.0,
                                      width: 40.0,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/icons/lock.png'),
                                            fit: BoxFit.fitHeight),
                                      ),
                                    ),
                                  ],
                                ),
                                suffixIcon: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ConstantColors().greyFive),
                                    borderRadius: BorderRadius.circular(9)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ConstantColors().primaryColor)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ConstantColors().warningColor)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ConstantColors().primaryColor)),
                                hintText:
                                    lnProvider.getString('Enter password'),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 18)),
                          )),

                      // =================>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //keep logged in checkbox
                          Expanded(
                            child: CheckboxListTile(
                              checkColor: Colors.white,
                              activeColor: ConstantColors().primaryColor,
                              contentPadding: const EdgeInsets.all(0),
                              title: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  asProvider.getString("Remember Me"),
                                  style: TextStyle(
                                      color: ConstantColors().greyFour,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                              value: keepLoggedIn,
                              onChanged: (newValue) {
                                setState(() {
                                  keepLoggedIn = !keepLoggedIn;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const ResetPassEmailPage(),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 122,
                              child: Text(
                                asProvider.getString("Forgot Password?"),
                                style: TextStyle(
                                    color: cc.primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                      ),

                      //Login button ==================>
                      const SizedBox(
                        height: 13,
                      ),

                      Consumer<LoginService>(
                        builder: (context, provider, child) => CommonHelper()
                            .buttonOrange(asProvider.getString("Sign In"), () {
                          if (provider.isloading == false) {
                            if (_formKey.currentState!.validate()) {
                              provider
                                  .login(
                                      emailController.text.trim(),
                                      passwordController.text,
                                      context,
                                      keepLoggedIn)
                                  .then((value) {
                                if (value == true) {
                                  context.popTrue;
                                }
                              });

                              // Navigator.pushReplacement<void, void>(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         const LandingPage(),
                              //   ),
                              // );
                            }
                          }
                        },
                                isloading:
                                    provider.isloading == false ? false : true),
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text:
                                  lnProvider.getString("Don't have account?") +
                                      "  ",
                              style: const TextStyle(
                                  color: Color(0xff646464), fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignupPage()));
                                      },
                                    text: lnProvider.getString('Sign up'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: cc.primaryColor,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Divider (or)
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                            height: 1,
                            color: cc.greyFive,
                          )),
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 25),
                            child: Text(
                              asProvider.getString("OR"),
                              style: TextStyle(
                                  color: cc.greyPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            height: 1,
                            color: cc.greyFive,
                          )),
                        ],
                      ),

                      // login with google, facebook button ===========>
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<GoogleSignInService>(
                        builder: (context, gProvider, child) => InkWell(
                            onTap: () {
                              if (gProvider.isloading == false) {
                                gProvider.googleLogin(context);
                              }
                            },
                            child: LoginHelper().commonButton(
                                'assets/icons/google.png',
                                lnProvider.getString("Login with Google"),
                                isloading: gProvider.isloading == false
                                    ? false
                                    : true)),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<FacebookLoginService>(
                        builder: (context, fProvider, child) => InkWell(
                          onTap: () {
                            if (fProvider.isloading == false) {
                              fProvider.checkIfLoggedIn(context).then((v) {
                                if (v == true) {
                                  context.popTrue;
                                }
                              });
                            }
                          },
                          child: LoginHelper().commonButton(
                              'assets/icons/facebook.png',
                              lnProvider.getString("Login with Facebook"),
                              isloading:
                                  fProvider.isloading == false ? false : true),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
              // }
              // }),
            ],
          ),
        ),
      ),
    );
  }
}
