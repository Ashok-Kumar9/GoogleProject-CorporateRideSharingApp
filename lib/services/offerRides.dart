import 'dart:convert';

import 'package:corporate_ride_sharing/models/offer_rides_model.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:http/http.dart' as http;

import '../Models/user_model.dart';
import '../models/vehicle_model.dart';

String baseUrl = "http://ride-with-me-22.herokuapp.com/";

class OfferRidesService {
  Future<OfferRides> getRideOffers() async {
    try {
      final response =
      await http.get(Uri.parse("${baseUrl}api/ride-offer/"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${SharedPrefs().authToken}"
      });
      if (response.statusCode == 200) {
        return  OfferRides.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data $response');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}
