import 'dart:math';

import 'package:corporate_ride_sharing/services/requestRides.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../Models/user_model.dart';
import '../../components/animation_dialog.dart';
import '../../components/reusable_widgets.dart';
import '../../models/request_rides_model.dart';
import '../../services/user_services.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import '../../utils/sharedPrefs/shared_prefs.dart';
import '../../utils/style.dart';

class SelectRide extends StatefulWidget {
  const SelectRide({Key? key}) : super(key: key);

  @override
  State<SelectRide> createState() => _SelectRideState();
}

class _SelectRideState extends State<SelectRide> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late RequestRides requestRides;
  bool isLoading = true;
  List<UserData> users = [];
  String sourceAddress =
      "Himalaya Mess Rd, Indian Institute Of Technology, Chennai, Tamil Nadu 600036";
  String destinationAddress =
      "Airport Rd, Meenambakkam, Chennai, Tamil Nadu 600027";

  @override
  void initState() {
    super.initState();
    getUserData();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
  }

  void getUserData() async {
    requestRides = await RequestRidesService().getRideRequests();
    // for(int i  = 0; i < requestRides.rideRequest.length; i++){
    //   UserData userData = await UserRemoteService().getUserData(requestRides.rideRequest[i].userId ?? "");
    //   if(userData != null){
    //     print(userData);
    //   users.add(userData);
    //   }
    // }
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
          automaticallyImplyLeading: false,
          title:
              Text("select your rider", style: Theme.of(context).textTheme.h3),
        ),
        body: isLoading
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
                          child: ReusableWidgets().buildCachedImageWithBlurHash(
                            AppConstants.defaultUserImageUrl,
                            blurHash: AppConstants.defaultUserImageBlurHash,
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
            : ListView.builder(
                itemCount: requestRides.rideRequest.length,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    // height: screenHeight * 0.22,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
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
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.watch_later_rounded,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    DateFormat('kk:mm a - dd/MM/yyyy')
                                        .format(requestRides.rideRequest[index]
                                                .startingTime ??
                                            DateTime.now())
                                        .toString(),
                                    style: Theme.of(context).textTheme.h5,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.my_location_rounded,
                                  color: ColorShades.googleRed,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    sourceAddress,
                                    style: Theme.of(context).textTheme.h5,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                const Icon(Icons.near_me_rounded,
                                    color: ColorShades.googleGreen, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    destinationAddress,
                                    style: Theme.of(context).textTheme.h5,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                const Icon(
                                    Icons.wifi_tethering_error_rounded_sharp,
                                    color: Colors.yellow,
                                    size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    requestRides.rideRequest[index].rideStatus
                                                .toString() ==
                                            "YET_TO_START"
                                        ? "Yet to start"
                                        : "Completed",
                                    style: Theme.of(context).textTheme.h5,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  ReusableWidgets().showToast(
                                      "rider is notified and will be here soon");
                                  SharedPrefs().rideRequestStatus = "posted";
                                  animationDialog(context,
                                      animationController: _animationController,
                                      jsonFileName: "ride_success");
                                },
                                child: const Text("send request")),
                          ],
                        )
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
