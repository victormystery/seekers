import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/app_string_service.dart';
import 'package:seeker_ng/service/auth_services/signup_service.dart';
import 'package:seeker_ng/service/dropdowns_services/area_dropdown_service.dart';
import 'package:seeker_ng/service/dropdowns_services/state_dropdown_services.dart';
import 'package:seeker_ng/view/auth/signup/components/country_states_dropdowns.dart';
import 'package:seeker_ng/view/auth/signup/signup_helper.dart';
import 'package:seeker_ng/view/utils/common_helper.dart';
import 'package:seeker_ng/view/utils/constant_colors.dart';
import 'package:seeker_ng/view/utils/others_helper.dart';
import 'package:seeker_ng/view/utils/responsive.dart';

class SignupCountryStates extends StatefulWidget {
  const SignupCountryStates({
    Key? key,
    this.fullNameController,
    this.userNameController,
    this.emailController,
    this.passController,
  }) : super(key: key);

  final fullNameController;
  final userNameController;
  final emailController;
  final passController;

  @override
  _SignupCountryStatesState createState() => _SignupCountryStatesState();
}

class _SignupCountryStatesState extends State<SignupCountryStates> {
  @override
  void initState() {
    super.initState();
  }

  bool termsAgree = false;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<AppStringService>(
      builder: (context, asProvider, child) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const CountryStatesDropdowns(),
              //Agreement checkbox ===========>
              const SizedBox(
                height: 17,
              ),
              CheckboxListTile(
                checkColor: Colors.white,
                activeColor: ConstantColors().primaryColor,
                contentPadding: const EdgeInsets.all(0),
                title: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    asProvider
                        .getString("I agree with the terms and conditions"),
                    style: TextStyle(
                        color: ConstantColors().greyFour,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                value: termsAgree,
                onChanged: (newValue) {
                  setState(() {
                    termsAgree = !termsAgree;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              //Login button ==================>
              const SizedBox(
                height: 17,
              ),
              Consumer<SignupService>(
                builder: (context, provider, child) => CommonHelper()
                    .buttonOrange(lnProvider.getString("Sign Up"), () {
                  if (termsAgree == false) {
                    OthersHelper().showToast(
                        asProvider.getString(
                            "You must agree with the terms and conditions to register"),
                        Colors.black);
                  } else {
                    if (provider.isloading == false) {
                      var selectedStateId = Provider.of<StateDropdownService>(
                              context,
                              listen: false)
                          .selectedStateId;
                      var selectedAreaId = Provider.of<AreaDropdownService>(
                              context,
                              listen: false)
                          .selectedAreaId;
                      if (selectedStateId == '0' ||
                          selectedAreaId == '0' ||
                          selectedAreaId == null) {
                        OthersHelper().showSnackBar(
                            context,
                            asProvider
                                .getString("You must select a state and area"),
                            cc.warningColor);
                        return;
                      }

                      provider.signup(
                          widget.fullNameController.text.trim(),
                          widget.emailController.text.trim(),
                          widget.userNameController.text.trim(),
                          widget.passController.text.trim(),
                          context);
                    }
                  }
                }, isloading: provider.isloading == false ? false : true),
              ),

              const SizedBox(
                height: 25,
              ),
              SignupHelper().haveAccount(context),

              const SizedBox(
                height: 30,
              ),
            ],
          )),
    );
  }
}
