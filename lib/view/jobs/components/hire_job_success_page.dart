import 'package:flutter/material.dart';
import 'package:seeker_ng/view/utils/common_helper.dart';
import 'package:seeker_ng/view/utils/constant_colors.dart';
import 'package:seeker_ng/view/utils/constant_styles.dart';
import 'package:seeker_ng/view/utils/responsive.dart';

class HireJobSuccessPage extends StatefulWidget {
  const HireJobSuccessPage({
    Key? key,
  }) : super(key: key);

  @override
  _HireJobSuccessPageState createState() => _HireJobSuccessPageState();
}

class _HireJobSuccessPageState extends State<HireJobSuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  final cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Success', context, () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenPadding),
          child: Container(
            height: screenHeight - 180,
            alignment: Alignment.center,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: cc.successColor,
                    size: 85,
                  ),
                  sizedBoxCustom(7),
                  Text(
                    lnProvider.getString('Hired successfully'),
                    style: TextStyle(
                        color: cc.greyFour,
                        fontSize: 21,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
          ),
        )));
  }
}
