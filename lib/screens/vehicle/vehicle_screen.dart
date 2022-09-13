import 'package:corporate_ride_sharing/components/custom_button.dart';
import 'package:corporate_ride_sharing/components/reusable_widgets.dart';
import 'package:corporate_ride_sharing/services/vehicle_services.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/vehicle_model.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({Key? key}) : super(key: key);

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _vehicleDetailsController =
      TextEditingController();
  bool isTwoWheeler = false;
  int vehicleCapacity = 4;

  void toggleVehicle() => setState(() {
        isTwoWheeler = !isTwoWheeler;
      });

  void changeCapacity(int capacity) => setState(() {
        vehicleCapacity = capacity;
      });

  late Vehicle vehicleData;
  bool isVehicleAlreadyExists = true;
  bool isVehicleLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    vehicleData =
        await VehicleRemoteService().getVehicle().onError((error, stackTrace) {
      isVehicleAlreadyExists = false;
      return Vehicle(message: error.toString(), vehicle: VehicleClass());
    });
    if (isVehicleAlreadyExists) {
      _vehicleNameController.text = vehicleData.vehicle.vehicleName ?? "";
      _vehicleNumberController.text = vehicleData.vehicle.vehicleNumber ?? "";
      _vehicleDetailsController.text = vehicleData.vehicle.vehicleDetails ?? "";
      isTwoWheeler = (vehicleData.vehicle.vehicleType == "BIKE");
      vehicleCapacity = vehicleData.vehicle.maxCapacity ?? 4;
    }
    setState(() => isVehicleLoading = false);
  }

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
          title: Text("add vehicle", style: Theme.of(context).textTheme.h3),
        ),
        body: isVehicleLoading
            ? ReusableWidgets().threeBounceLoader()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ReusableWidgets().coloredTextContainer(
                              context,
                              toggleVehicle,
                              "Car",
                              isTwoWheeler
                                  ? ColorShades.lightGrey
                                  : ColorShades.greenDark),
                          ReusableWidgets().coloredTextContainer(
                              context,
                              toggleVehicle,
                              "Bike/Scooter",
                              isTwoWheeler
                                  ? ColorShades.greenDark
                                  : ColorShades.lightGrey),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/svg/${isTwoWheeler ? "bike" : "car"}.svg',
                          width: screenWidth * 0.6,
                          placeholderBuilder: (context) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        "vehicle name",
                        style: Theme.of(context).textTheme.h5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecorations().textFieldBox,
                        child: Center(
                          child: TextField(
                            controller: _vehicleNameController,
                            cursorColor: Colors.white,
                            style: Theme.of(context).textTheme.h4,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .h4
                                    .copyWith(color: Colors.grey),
                                hintText: "Tata Nexon",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        "registration number",
                        style: Theme.of(context).textTheme.h5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecorations().textFieldBox,
                        child: Center(
                          child: TextField(
                            controller: _vehicleNumberController,
                            cursorColor: Colors.white,
                            style: Theme.of(context).textTheme.h4,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .h4
                                    .copyWith(color: Colors.grey),
                                hintText: 'Registration No. (RJ18 5612)',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      if (!isTwoWheeler)
                        Text(
                          "vehicle capacity",
                          style: Theme.of(context).textTheme.h5,
                        ),
                      if (!isTwoWheeler)
                        Padding(
                          padding: EdgeInsets.only(
                              top: 16.0, bottom: screenHeight * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (int i = 1; i < 6; i++)
                                ReusableWidgets().coloredTextContainer(
                                  context,
                                  () => changeCapacity(i),
                                  i.toString(),
                                  i == vehicleCapacity
                                      ? ColorShades.greenDark
                                      : ColorShades.lightGrey,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                ),
                            ],
                          ),
                        ),
                      Text(
                        "vehicle details",
                        style: Theme.of(context).textTheme.h5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecorations().textFieldBox,
                        child: Center(
                          child: TextField(
                            controller: _vehicleDetailsController,
                            cursorColor: Colors.white,
                            style: Theme.of(context).textTheme.h4,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .h4
                                    .copyWith(color: Colors.grey),
                                hintText:
                                    'add details of the vehicle (optional)',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      CustomButton(
                        isActive: _vehicleNameController.text.isNotEmpty &&
                            _vehicleNumberController.text.isNotEmpty,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          vehicleData.vehicle.vehicleType =
                              isTwoWheeler ? "BIKE" : "CAR";
                          vehicleData.vehicle.vehicleName =
                              _vehicleNameController.text;
                          vehicleData.vehicle.vehicleNumber =
                              _vehicleNumberController.text;
                          vehicleData.vehicle.vehicleDetails =
                              _vehicleDetailsController.text;
                          vehicleData.vehicle.maxCapacity = vehicleCapacity;

                          Vehicle newVehicleData = await VehicleRemoteService()
                              .putVehicle(vehicleData.vehicle)
                              .onError((error, stackTrace) => Vehicle(
                                  message: error.toString(),
                                  vehicle: vehicleData.vehicle));

                          if (!mounted) return;
                          if (newVehicleData.message ==
                              "vehicle updated successfully") {
                            ReusableWidgets().showToast(newVehicleData.message);
                            Navigator.pop(context);
                          } else {
                            ReusableWidgets().showToast(
                                "error while updating vehicle! try again");
                          }
                        },
                        child: Center(
                          child: Text(
                            "add vehicle",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.h3,
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
