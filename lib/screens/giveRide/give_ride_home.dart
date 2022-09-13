import 'dart:async';

import 'package:corporate_ride_sharing/components/reusable_widgets.dart';
import 'package:corporate_ride_sharing/models/offer_rides_model.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../../Models/address_model.dart';
import '../../Models/direction_details.dart';
import '../../services/requestHelper.dart';
import '../../utils/constants.dart';

class GiveRideHome extends StatefulWidget {
  const GiveRideHome({Key? key}) : super(key: key);

  @override
  State<GiveRideHome> createState() => _GiveRideHomeState();
}

class _GiveRideHomeState extends State<GiveRideHome> {
  final Completer<GoogleMapController> _mapController = Completer();
  late GoogleMapController _newGoogleMapController;

  late CameraPosition cameraPosition;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  Set<Marker> markers = {};
  Set<Circle> circle = {};

  DirectionDetails? tripDirectionDetails;

  static const LatLng initialCameraPosition = LatLng(12.999900, 80.241250);
  LatLng sourceLocation = const LatLng(12.999900, 80.241250);
  String sourceAddress =
      "Himalaya Mess Rd, Indian Institute Of Technology, Chennai, Tamil Nadu 600036";
  LatLng destinationLocation = const LatLng(12.995740, 80.210297);
  String destinationAddress =
      "Airport Rd, Meenambakkam, Chennai, Tamil Nadu 600027";
  List<LatLng> polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: initialCameraPosition,
                zoom: 14.5,
              ),
              polylines: polyLineSet,
              markers: markers,
              circles: circle,
              onMapCreated: (cont) async {
                _mapController.complete(cont);
                _newGoogleMapController = cont;

                await locateSourcePosition();
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorShades.backGroundGrey.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 16,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => locateDestinationPosition(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorShades.backGroundBlack,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Icon(Icons.search),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Search"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            mini: true,
                            backgroundColor: ColorShades.blue,
                            onPressed: () async {
                              // var response = await OfferRidesService().getRideOffers();
                              // print("response is $response");
                              // print("message is ${response.message}");
                              // print("rideoffer is ${response.rideOffer[0].boardingPoint?.coordinates[0]}");

                              RideOffer rideOffer = RideOffer(
                                rideStatus: "YET_TO_START",
                                currentPoint: Point(coordinates: [
                                  sourceLocation.longitude,
                                  sourceLocation.longitude
                                ]),
                                boardingPoint: Point(coordinates: [
                                  sourceLocation.longitude,
                                  sourceLocation.longitude
                                ]),
                                destinationPoint: Point(coordinates: [
                                  destinationLocation.longitude,
                                  destinationLocation.longitude
                                ]),
                                userId: SharedPrefs().userId,
                              );

                              ReusableWidgets().noOfSeatsAlertDialogue(
                                context,
                                height * 0.1,
                                width * 0.8,
                                rideOffer: rideOffer,
                              );
                            },
                            child: const Icon(
                              Icons.forward,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // for getting the current location of the user
  locateSourcePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    sourceLocation = LatLng(position.latitude, position.longitude);
    cameraPosition = CameraPosition(target: sourceLocation, zoom: 13.5);
    _newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() async {
      sourceAddress = await searchCoordinatesAddress(position);
    });
  }

  // for getting the destination location of the user
  locateDestinationPosition() async {
    Prediction p = await PlacesAutocomplete.show(
          context: context,
          apiKey: AppConstants.mapsKey,
          mode: Mode.overlay,
          types: ['(regions)'],
          // mode: Mode.fullscreen,
          language: "en",
          components: [Component(Component.country, "in")],
        ) ??
        Prediction();
    PlacesDetailsResponse detail =
        await GoogleMapsPlaces(apiKey: AppConstants.mapsKey)
            .getDetailsByPlaceId(p.placeId ?? "");
    double lat = detail.result.geometry?.location.lat ?? 0.0;
    double lng = detail.result.geometry?.location.lng ?? 0.0;
    destinationLocation = LatLng(lat, lng);
    setState(() async {
      destinationAddress = await searchCoordinatesAddress(Position(
          longitude: destinationLocation.longitude,
          latitude: destinationLocation.latitude,
          timestamp: null,
          accuracy: 1.0,
          altitude: 1.0,
          heading: 1.0,
          speed: 1.0,
          speedAccuracy: 1.0));
    });
  }

  // for getting current location from latitude and longitude
  static Future<String> searchCoordinatesAddress(Position position) async {
    String placeAddress = '';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${AppConstants.mapsKey}';
    var response = await RequestHelper.getRequest(url);
    // print("placeAddress: $response");

    if (response != "Error") {
      placeAddress = response["results"][0]['formatted_address'];
      final placeName =
          response["results"][0]['address_components'][3]['long_name'];
      final placeId = response["results"][0]['place_id'];
      Address address = Address(
        placeAddress,
        placeName,
        placeId,
        position.latitude,
        position.longitude,
      );
    }
    return placeAddress;
  }

  // for getting polyline from source to destination
  void getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConstants.mapsKey,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {});
  }

  // for getting the direction from source to destination
  static Future<dynamic> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=${AppConstants.mapsKey}";
    var res = await RequestHelper.getRequest(directionUrl);
    if (res == "Error") {
      return null;
    }
    var distanceText = res['routes'][0]['legs'][0]['distance']['text'];
    var distanceValue = res['routes'][0]['legs'][0]['distance']['value'];
    var durationText = res['routes'][0]['legs'][0]['duration']['text'];
    var durationValue = res['routes'][0]['legs'][0]['duration']['value'];
    var encodedPoints = res['routes'][0]['overview_polyline']['points'];
    DirectionDetails details = DirectionDetails(distanceText, distanceValue,
        durationText, durationValue, encodedPoints);

    return details;
  }

  // for getting the direction from source to destination and adding points on the map
  Future<void> getPlaceDirection() async {
    var initialPosition = sourceLocation;
    var dropOffPosition = destinationLocation;

    var pickUpLatLng =
        LatLng(initialPosition.latitude, initialPosition.longitude);

    var dropOffLatLng =
        LatLng(dropOffPosition.latitude, dropOffPosition.longitude);

    DirectionDetails details =
        await obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if (decodePolyLinePointsResult.isNotEmpty) {
      for (var element in decodePolyLinePointsResult) {
        pLineCoordinates.add(LatLng(element.latitude, element.longitude));
      }
    }

    polyLineSet.clear();
    Polyline polyline = Polyline(
      polylineId: const PolylineId('PolyLineId'),
      color: Colors.amber,
      jointType: JointType.round,
      points: pLineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    setState(() {
      polyLineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
      );
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
      );
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    _newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    // Marker pickUpMarker = Marker(
    //     markerId: const MarkerId("PickUpId"),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    //     infoWindow: InfoWindow(
    //       title: initialPosition.placeFormatAddress,
    //       snippet: "My Location",
    //     ),
    //     position: pickUpLatLng);
    //
    // Marker dropOffMarker = Marker(
    //     markerId: const MarkerId("dropOffMarker"),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueRed,
    //     ),
    //     infoWindow: InfoWindow(
    //       title: dropOffPosition.placeFormatAddress,
    //       snippet: "Drop Off Location",
    //     ),
    //     position: dropOffLatLng);

    // setState(() {
    //   markers.add(dropOffMarker);
    //   markers.add(pickUpMarker);
    // });

    Circle pickUpCircle = Circle(
      fillColor: Colors.amber,
      radius: 12,
      circleId: const CircleId("PickupCircle"),
      center: pickUpLatLng,
      strokeWidth: 4,
      strokeColor: Colors.amber,
    );

    Circle dropOffCircle = Circle(
      fillColor: Colors.pink.shade300,
      radius: 12,
      circleId: const CircleId("dropOffCircle"),
      center: dropOffLatLng,
      strokeWidth: 4,
      strokeColor: Colors.pink.shade300,
    );

    setState(() {
      circle.add(pickUpCircle);
      circle.add(dropOffCircle);
    });
  }
}
