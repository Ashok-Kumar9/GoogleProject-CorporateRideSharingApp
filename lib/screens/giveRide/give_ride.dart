import 'package:corporate_ride_sharing/components/custom_button.dart';
import 'package:corporate_ride_sharing/components/reusable_widgets.dart';
import 'package:corporate_ride_sharing/services/vehicle_services.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/offer_rides_model.dart';
import '../../models/vehicle_model.dart';
import '../../services/offerRides.dart';

class GiveRide extends StatefulWidget {
  GiveRide({Key? key, required this.rideOffer}) : super(key: key);

  RideOffer rideOffer;

  @override
  State<GiveRide> createState() => _GiveRideState();
}

class _GiveRideState extends State<GiveRide> {
  String sourceAddress =
      "Himalaya Mess Rd, Indian Institute Of Technology, Chennai, Tamil Nadu 600036";
  String destinationAddress =
      "Airport Rd, Meenambakkam, Chennai, Tamil Nadu 600027";
  int vehicleCapacity = 4;
  String rideStatus = "";

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
          title: Text("offer ride", style: Theme.of(context).textTheme.h3),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.supervised_user_circle_sharp,
                      color: ColorShades.white),
                  const SizedBox(width: 18),
                  Text("vehicle capacity",
                      style: Theme.of(context)
                          .textTheme
                          .h4
                          .copyWith(color: Colors.grey)),
                  const SizedBox(width: 18),
                  ReusableWidgets().coloredTextContainer(
                    context,
                    () {},
                    (widget.rideOffer.availableSeats).toString(),
                    ColorShades.greenDark,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                  )
                ],
              ),
              const Spacer(),
              CustomButton(
                isActive: rideStatus == "",
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
                  String result = await OfferRidesService().createRideOffer(widget.rideOffer);
                  print(result);
                },
                child: Center(
                  child: Text(
                    "update ride",
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
