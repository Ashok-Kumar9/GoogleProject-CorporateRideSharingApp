import 'dart:convert';

import 'package:corporate_ride_sharing/models/offer_rides_model.dart';
import 'package:corporate_ride_sharing/models/request_rides_model.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:http/http.dart' as http;

import '../Models/user_model.dart';
import '../models/vehicle_model.dart';

String baseUrl = "http://ride-with-me-22.herokuapp.com/";

class RequestRidesService {
  Future<RequestRides> getRideRequests() async {
    try {
      final response =
      await http.get(Uri.parse("${baseUrl}api/ride-request/"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${SharedPrefs().authToken}"
      });
      if (response.statusCode == 200) {
        return  RequestRides.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data $response');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  createRideRequest(RideRequest rideRequest) async {
    try {
      final response =
      await http.post(Uri.parse("${baseUrl}api/ride-request/"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${SharedPrefs().authToken}"
      }, body: jsonEncode(rideRequest.toJson()));

      if (response.statusCode == 200) {
        return  response.body;
      } else {
        throw Exception('Failed to load data $response');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}
