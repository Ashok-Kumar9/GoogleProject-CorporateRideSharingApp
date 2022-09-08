import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../Models/user_data.dart';
import '../../services/remote_service.dart';

class RoleSelection extends StatelessWidget {
  const RoleSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorShades.backGroundBlack,
          body: Container(
            height: screenHeight - MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(top: screenHeight * 0.1),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0.0,
                  child: Lottie.asset(
                    'assets/animations/black_car.json',
                    width: screenWidth,
                    errorBuilder: (context, e, s) => const SizedBox.shrink(),
                  ),
                ),
                FutureBuilder(
                  future: RemoteService().getUserData(SharedPrefs().userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserData userData = snapshot.data as UserData;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.08),
                            child: Text(
                              "select your role",
                              style: Theme.of(context).textTheme.h2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          roleContainer(
                            context,
                            screenHeight,
                            screenWidth,
                            'assets/images/svg/role1_take.svg',
                            'Passenger',
                            'searching for rides?',
                            userData.user.role != "PASSENGER",
                          ),
                          const SizedBox(height: 16.0),
                          roleContainer(
                            context,
                            screenHeight,
                            screenWidth,
                            'assets/images/svg/role2_give.svg',
                            'Rider',
                            'wish to share your ride?',
                            userData.user.role != "RIDER",
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.08),
                            child: Text(
                              "select your role",
                              style: Theme.of(context).textTheme.h2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          roleContainer(
                            context,
                            screenHeight,
                            screenWidth,
                            'assets/images/svg/role1_take.svg',
                            'Passenger',
                            'searching for rides?',
                            true,
                          ),
                          const SizedBox(height: 16.0),
                          roleContainer(
                            context,
                            screenHeight,
                            screenWidth,
                            'assets/images/svg/role2_give.svg',
                            'Rider',
                            'wish to share your ride?',
                            true,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }

  GestureDetector roleContainer(
      BuildContext context,
      double screenHeight,
      double screenWidth,
      String imagePath,
      String title,
      String description,
      bool isSelected) {
    return GestureDetector(
      onTap: () {
        SharedPrefs().userRole = title.toUpperCase();
        Navigator.popAndPushNamed(context, '/user_profile');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color:
              isSelected ? ColorShades.backGroundGrey : ColorShades.greenDark,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imagePath,
              height: screenHeight * 0.1,
              placeholderBuilder: (context) => const SizedBox.shrink(),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: title,
                  style: Theme.of(context).textTheme.h4,
                  children: [
                    TextSpan(
                      text: "\n$description",
                      style: Theme.of(context).textTheme.h6.copyWith(height: 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
