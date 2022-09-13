import 'package:corporate_ride_sharing/services/requestHelper.dart';
import 'package:corporate_ride_sharing/utils/constants.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';

import '../../Models/address_model.dart';
import '../../Models/place_prediction.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

TextEditingController _dropoffController = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _pickupController = TextEditingController();

  List<PlacePrediction> predictionList = [];

  @override
  Widget build(BuildContext context) {
    const place = "";
    _pickupController.text = place;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorShades.backGroundGrey,
        body: Column(
          children: [
            Container(
              height: 215,
              decoration: BoxDecoration(
                color: ColorShades.backGroundGrey.withOpacity(0.6),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.arrow_back),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const Center(
                          child: Text(
                            "Set Drop Off",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.my_location_rounded,
                            color: ColorShades.googleRed),
                        const SizedBox(width: 18),
                        Expanded(
                          child:  Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecorations().textFieldBox,
                            child: Center(
                              child: TextField(
                                controller: _pickupController,
                                cursorColor: Colors.white,
                                style: Theme.of(context).textTheme.h4,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .h4
                                        .copyWith(color: Colors.grey),
                                    hintText: "pick up location",
                                    border: InputBorder.none),
                              ),
                            ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecorations().textFieldBox,
                            child: Center(
                              child: TextField(
                                controller: _dropoffController,
                                cursorColor: Colors.white,
                                style: Theme.of(context).textTheme.h4,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  findPlace(value);
                                },
                                decoration: InputDecoration(
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .h4
                                        .copyWith(color: Colors.grey),
                                    hintText: "drop off location",
                                    border: InputBorder.none),
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (predictionList.isNotEmpty)
              Expanded(
                child: ListView(
                    children: predictionList.map((e) {
                  return PredictionTile(e);
                }).toList()),
              ),
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&types=establishment&radius=500&key=${AppConstants.mapsKey}&components=country:in";
      final result = await RequestHelper.getRequest(autoCompleteUrl);

      if (result == 'Error') {
        return;
      }

      if (result['status'] == 'OK') {
        var predictions = result['predictions'];

        var placeList = (predictions as List).map((e) {
          return PlacePrediction.fromJSON(e);
        }).toList();

        setState(() {
          predictionList = placeList;
        });
      }

      print(result);
    }
  }
}

class PredictionTile extends StatelessWidget {
  late final PlacePrediction placePrediction;

  PredictionTile(placePrediction) {
    this.placePrediction = placePrediction;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        getPlaceAddressDetails(placePrediction.place_id, context);
      },
      leading: const Icon(Icons.add_location),
      title: Text(placePrediction.main_text),
      subtitle: Text(placePrediction.secondary_text),
    );
  }

  void getPlaceAddressDetails(String place_id, BuildContext context) async {
    String detail_url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$place_id&key=${AppConstants.mapsKey}";

    var res = await RequestHelper.getRequest(detail_url);

    if (res == "Error") {
      return;
    }

    if (res['status'] == "OK") {
      final placeformatAddress = res['result']['formatted_address'];
      final placeName = res['result']['address_components'][2]['long_name'];
      final placeId = place_id;
      final latitude = res['result']['geometry']['location']['lat'];
      final longitude = res['result']['geometry']['location']['lng'];
      Address address =
          Address(placeformatAddress, placeName, placeId, latitude, longitude);

      Navigator.of(context).pop("ObtainDirections");
    }
  }
}
