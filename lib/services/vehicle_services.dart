import 'dart:convert';

import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:http/http.dart' as http;

import '../Models/user_model.dart';
import '../models/vehicle_model.dart';

String baseUrl = "http://ride-with-me-22.herokuapp.com/";

class VehicleRemoteService {
  Future<Vehicle> getVehicle() async {
    try {
      final response =
          await http.get(Uri.parse("${baseUrl}api/vehicle/${SharedPrefs().vehicleId}"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${SharedPrefs().authToken}"
      });
      if (response.statusCode == 200) {
        return  Vehicle.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data $response');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Vehicle> putVehicle(VehicleClass vehicleData) async {
    try {
      final response = await http.put(Uri.parse("${baseUrl}api/vehicle/${SharedPrefs().vehicleId}"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer ${SharedPrefs().authToken}"
          },
          body: jsonEncode(vehicleData.toJson()));
      if (response.statusCode == 200) {
        return Vehicle.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
