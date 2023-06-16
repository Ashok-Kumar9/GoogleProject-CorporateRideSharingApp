import 'dart:convert';

import 'package:corporate_ride_sharing/components/custom_button.dart';
import 'package:corporate_ride_sharing/components/reusable_widgets.dart';
import 'package:corporate_ride_sharing/models/request_rides_model.dart';
import 'package:corporate_ride_sharing/screens/requestRide/select_ride.dart';
import 'package:corporate_ride_sharing/services/requestRides.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../components/animation_dialog.dart';
import '../../models/offer_rides_model.dart';
import '../../services/offerRides.dart';

class RequestRide extends StatefulWidget {
  RequestRide({Key? key, required this.rideRequest}) : super(key: key);

  RideRequest rideRequest;

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
  String sourceAddress =
      "Himalaya Mess Rd, Indian Institute Of Technology, Chennai, Tamil Nadu 600036";
  String destinationAddress =
      "Airport Rd, Meenambakkam, Chennai, Tamil Nadu 600027";
  int vehicleCapacity = -1;
  String rideStatus = "YET_TO_START";
  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorShades.backGroundGrey,
        appBar: AppBar(
          backgroundColor: ColorShades.backGroundBlack,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          automaticallyImplyLeading: false,
          title: Text("request ride", style: Theme.of(context).textTheme.h3),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/images/svg/car.svg',
                  width: screenWidth * 0.6,
                  placeholderBuilder: (context) => const SizedBox.shrink(),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  const Icon(Icons.my_location_rounded,
                      color: ColorShades.googleRed),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecorations().textFieldBox,
                      child: Text(sourceAddress,
                          style: Theme.of(context)
                              .textTheme
                              .h4
                              .copyWith(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.near_me_rounded,
                      color: ColorShades.googleGreen),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecorations().textFieldBox,
                      child: Text(destinationAddress,
                          style: Theme.of(context)
                              .textTheme
                              .h4
                              .copyWith(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.grey,
                height: 40.0,
                thickness: 1,
              ),
              Row(
                children: [
                  const Icon(Icons.supervised_user_circle_sharp,
                      color: ColorShades.white),
                  const SizedBox(width: 18),
                  Text("seats required",
                      style: Theme.of(context)
                          .textTheme
                          .h4
                          .copyWith(color: Colors.grey)),
                  const SizedBox(width: 18),
                  // ReusableWidgets().coloredTextContainer(
                  //   context,
                  //   () {},
                  //   (widget.rideOffer.availableSeats).toString(),
                  //   ColorShades.greenDark,
                  //   margin: const EdgeInsets.symmetric(horizontal: 2),
                  // )
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                children: [
                  for (int i = 1; i < 6; i++)
                    ReusableWidgets().coloredTextContainer(
                      context,
                      () {
                        setState(() {
                          vehicleCapacity = i;
                        });
                      },
                      i.toString(),
                      i == vehicleCapacity
                          ? ColorShades.greenDark
                          : ColorShades.lightGrey,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                children: [
                  const Icon(Icons.watch_later_rounded,
                      color: ColorShades.white),
                  const SizedBox(width: 18),
                  Text("select ride time",
                      style: Theme.of(context)
                          .textTheme
                          .h4
                          .copyWith(color: Colors.grey)),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              GestureDetector(
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    setState(() {
                      final now = DateTime.now();
                      time = DateTime(now.year, now.month, now.day,
                          value?.hour ?? 0, value?.minute ?? 0);
                    });
                  });
                },
                child: Container(
                  width: screenWidth,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecorations().textFieldBox,
                  child: Text(
                      DateFormat('kk:mm a - dd/MM/yyyy')
                          .format(time)
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .h4
                          .copyWith(color: Colors.grey)),
                ),
              ),
              const Spacer(),
              CustomButton(
                isActive: vehicleCapacity != -1,
                onPressed: () async {
                  // widget.rideOffer.rideStatus = rideStatus;
                  //
                  // Vehicle newVehicleData = await VehicleRemoteService()
                  //     .putVehicle(vehicleData.vehicle)
                  //     .onError((error, stackTrace) => Vehicle(
                  //         message: error.toString(),
                  //         vehicle: vehicleData.vehicle));
                  //
                  // if (!mounted) return;
                  // if (newVehicleData.message ==
                  //     "vehicle updated successfully") {
                  //   ReusableWidgets().showToast(newVehicleData.message);
                  //   Navigator.pop(context);
                  // } else {
                  //   ReusableWidgets()
                  //       .showToast("error while updating vehicle! try again");
                  // }

                  widget.rideRequest.rideStatus = rideStatus;
                  widget.rideRequest.seatsRequired = vehicleCapacity;
                  widget.rideRequest.startingTime = time;

                  print(widget.rideRequest.toJson());

                  var result = await RequestRidesService()
                      .createRideRequest(widget.rideRequest);
                  result = jsonDecode(result);

                  print("result is $result");
                  print(result.runtimeType);

                  if (result["message"] ==
                      "Ride request created successfully") {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SelectRide()));
                    ReusableWidgets().showToast(result["message"]);
                  } else {
                    ReusableWidgets().showToast(
                        "error while creating ride offer! try again");
                  }

                  print(result);
                },
                child: Center(
                  child: Text(
                    "request ride",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.h3,
                    // textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
