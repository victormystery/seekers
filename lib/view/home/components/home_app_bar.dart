import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/profile_service.dart';
import 'package:seeker_ng/view/tabs/settings/profile_edit.dart';
import 'package:seeker_ng/view/utils/common_helper.dart';
import 'package:seeker_ng/view/utils/constant_colors.dart';
import 'package:seeker_ng/view/utils/responsive.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
    required this.cc,
  }) : super(key: key);

  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileService>(
      builder: (context, profileProvider, child) =>
          profileProvider.profileDetails != null
              ? profileProvider.profileDetails != 'error'
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const ProfileEditPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            //name
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lnProvider.getString('Welcome')}!',
                                  style: TextStyle(
                                    color: cc.greyParagraph,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  profileProvider
                                          .profileDetails.userDetails.name ??
                                      '',
                                  style: TextStyle(
                                    color: cc.greyFour,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),

                            //profile image
                            profileProvider.profileImage != null
                                ? CommonHelper().profileImage(
                                    profileProvider.profileImage, 52, 52)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/avatar.png',
                                      height: 52,
                                      width: 52,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  : const GuestAppBar()
              : const GuestAppBar(),
    );
  }
}

class GuestAppBar extends StatelessWidget {
  const GuestAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHelper().titleCommon("Hello! 👋", color: cc.black3),
          CommonHelper().titleCommon("Welcome to Seekers.Ng", color: cc.black3),
        ],
      ),
    );
  }
}
