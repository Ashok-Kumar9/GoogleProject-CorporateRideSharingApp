import 'dart:async';

import 'package:corporate_ride_sharing/screens/giveRide/search_screen.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Models/direction_details.dart';
import '../../helper/helper_methods.dart';
import '../../utils/constants.dart';

class GiveRide extends StatefulWidget {
  const GiveRide({Key? key}) : super(key: key);

  @override
  State<GiveRide> createState() => _GiveRideState();
}

class _GiveRideState extends State<GiveRide> {
  final Completer<GoogleMapController> _mapController = Completer();

  late GoogleMapController _newGoogleMapController;

  late Animation<Offset> sidebarAnimation;
  late Animation<double> fadeAnimation;
  late AnimationController sidebarAnimationController;
  var sidebarHidden = true;
  late CameraPosition cameraPosition;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  Set<Marker> markers = {};
  Set<Circle> circle = {};

  DirectionDetails? tripDirectionDetails;

  double locationPanel = 300;
  double riderDetailPanel = 0;
  double requestRidePanel = 0;

  static const LatLng initialCameraPosition = LatLng(12.999900, 80.241250);
  static const LatLng sourceLocation = LatLng(12.999900, 80.241250);
  static const LatLng destinationLocation = LatLng(12.995740, 80.210297);
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    getPolyPoint();
  }

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

  locatePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng ltlnPosition = LatLng(position.latitude, position.longitude);
    cameraPosition = CameraPosition(target: ltlnPosition, zoom: 13.5);
    _newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await HelperMethods.searchCoordinatesAddress(position, context);
  }

  void displayRideDetailContainer() async {
    await getPlaceDirection();

    setState(() {
      riderDetailPanel = 300;
      locationPanel = 0;
    });
  }

  Future<void> getPlaceDirection() async {
    var initialPosition;
    var dropoffPosition;

    var picupkLatLng =
        LatLng(initialPosition!.latitude, initialPosition.longitude);

    var dropOffLatLng =
        LatLng(dropoffPosition!.latitude, dropoffPosition.longitude);

    DirectionDetails details = await HelperMethods.obtainPlaceDirectionDetails(
        picupkLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if (decodePolyLinePointsResult.isNotEmpty) {
      decodePolyLinePointsResult.forEach((element) {
        pLineCoordinates.add(LatLng(element.latitude, element.longitude));
      });
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
    if (picupkLatLng.latitude > dropOffLatLng.latitude &&
        picupkLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: picupkLatLng);
    } else if (picupkLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(picupkLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, picupkLatLng.longitude),
      );
    } else if (picupkLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, picupkLatLng.longitude),
        northeast: LatLng(picupkLatLng.latitude, dropOffLatLng.longitude),
      );
    } else {
      latLngBounds =
          LatLngBounds(southwest: picupkLatLng, northeast: dropOffLatLng);
    }

    _newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpMarker = Marker(
        markerId: const MarkerId("PickUpId"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: initialPosition.placeFormatAddress,
          snippet: "My Location",
        ),
        position: picupkLatLng);

    Marker dropOffMarker = Marker(
        markerId: const MarkerId("dropOffMarker"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: dropoffPosition.placeFormatAddress,
          snippet: "Drop Off Location",
        ),
        position: dropOffLatLng);

    setState(() {
      markers.add(dropOffMarker);
      markers.add(pickUpMarker);
    });

    Circle pickUpCircle = Circle(
      fillColor: Colors.amber,
      radius: 12,
      circleId: const CircleId("PickupCircle"),
      center: picupkLatLng,
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

  @override
  Widget build(BuildContext context) {
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

                await locatePosition();
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
                        onTap: () async {
                          var res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));

                          if (res == "ObtainDirections") {
                            displayRideDetailContainer();
                          }
                        },
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
                            Icons.home,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Himalaya Mess Rd, Indian Institute Of Technology, Chennai, Tamil Nadu 600036",
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
                            Icons.location_on,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Airport Rd, Meenambakkam, Chennai, Tamil Nadu 600027",
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
                            onPressed: () {
                              Fluttertoast.showToast(msg: "ready to go");
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
}
