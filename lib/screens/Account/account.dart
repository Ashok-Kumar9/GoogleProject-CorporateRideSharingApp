import 'dart:math';

import 'package:corporate_ride_sharing/Models/user_data.dart';
import 'package:corporate_ride_sharing/components/animated_border.dart';
import 'package:corporate_ride_sharing/components/reusable_widgets.dart';
import 'package:corporate_ride_sharing/services/remote_service.dart';
import 'package:corporate_ride_sharing/utils/constants.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late UserData userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    userData =
        await RemoteService().getUserData("BmH9BPdF8mPc3A4VIa7S8vtW8rj2");
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorShades.backGroundGrey,
        appBar: AppBar(
          backgroundColor: ColorShades.backGroundBlack,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          automaticallyImplyLeading: false,
          title: Text("account", style: Theme.of(context).textTheme.h3),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              isLoading
                  ? Container(
                      height: screenHeight * 0.15,
                      margin: const EdgeInsets.symmetric(vertical: 24.0),
                      decoration: const BoxDecoration(
                        color: ColorShades.backGroundGrey,
                        boxShadow: [
                          BoxShadow(
                            color: ColorShades.backGroundBlack,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: ColorShades.lightGrey,
                        highlightColor: ColorShades.grey,
                        period: const Duration(milliseconds: 1000),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: SizedBox(
                                width: screenHeight * 0.1,
                                height: screenHeight * 0.1,
                                child: ReusableWidgets()
                                    .buildCachedImageWithBlurHash(
                                  AppConstants.defaultUserImageUrl,
                                  blurHash:
                                      AppConstants.defaultUserImageBlurHash,
                                  boxFit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 1; i < 4; i++)
                                    Container(
                                      color: Colors.white,
                                      margin: EdgeInsets.only(
                                          bottom: screenHeight * 0.01),
                                      height: 14.0,
                                      width: screenHeight *
                                          (Random().nextDouble() * 0.05 + 0.1),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: screenHeight * 0.15,
                      margin: const EdgeInsets.symmetric(vertical: 24.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: const BoxDecoration(
                        color: ColorShades.backGroundGrey,
                        boxShadow: [
                          BoxShadow(
                            color: ColorShades.backGroundBlack,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenHeight * 0.1,
                            height: screenHeight * 0.1,
                            child:
                                ReusableWidgets().buildCachedImageWithBlurHash(
                              userData.user.profileUrl ??
                                  AppConstants.defaultUserImageUrl,
                              blurHash: AppConstants.defaultUserImageBlurHash,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.user.fullName ?? "",
                                  style: Theme.of(context).textTheme.h3,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  userData.user.mobileNo??"",
                                  style: Theme.of(context).textTheme.h5,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  userData.user.emailId??"",
                                  style: Theme.of(context).textTheme.h5,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              GestureDetector(
                onTap: () {},
                child: AnimatedBorder(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      gradient: Gradients().referEarnContainerGradient,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              overflow: TextOverflow.visible,
                              text: TextSpan(
                                text: "refer and earn ₹ 50\n\n",
                                style: Theme.of(context)
                                    .textTheme
                                    .h4
                                    .copyWith(fontWeight: FontWeight.w900),
                                children: [
                                  TextSpan(
                                    text:
                                        "you’ll both get 50% off up to ₹ 50. it’s a win-win 😉",
                                    style: Theme.of(context).textTheme.h5,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          SvgPicture.asset(
                            'assets/images/svg/refer_earn.svg',
                            height: screenHeight * 0.1,
                            placeholderBuilder: (context) =>
                                const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              option(
                context,
                Icons.two_wheeler_rounded,
                "add vehicle",
                () => Navigator.pushNamed(context, '/vehicle'),
              ),
              option(
                context,
                Icons.support_agent_rounded,
                "help and support",
                () {},
              ),
              option(
                context,
                Icons.rate_review_rounded,
                "review us",
                () {},
              ),
              option(
                context,
                Icons.person_add,
                "refer us",
                () {},
              ),
              option(
                context,
                Icons.help_outline_rounded,
                "app info",
                () {},
              ),
              option(
                context,
                Icons.logout_rounded,
                "logout",
                () {
                  SharedPrefs().clearSharedPrefs();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/mobile',
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector option(
      BuildContext context, IconData iconData, String name, Function() onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.all(4.0),
          decoration: const BoxDecoration(
            color: ColorShades.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 28.0,
                color: ColorShades.blue,
              ),
              const SizedBox(width: 12.0),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .h3
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, size: 20)
            ],
          ),
        ));
  }
}
