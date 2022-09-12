import 'dart:convert';

import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:http/http.dart' as http;

import '../Models/user_model.dart';

String baseUrl = "http://ride-with-me-22.herokuapp.com/";

class UserRemoteService {
  Future<UserData> getUserData(String userId) async {
    try {
      final response =
          await http.get(Uri.parse("${baseUrl}api/user/$userId"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${SharedPrefs().authToken}"
      });
      if (response.statusCode == 200) {
        return UserData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data $response');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserData> postUserData(User userData) async {
    try {
      final response = await http.post(Uri.parse("${baseUrl}api/user/"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer ${SharedPrefs().authToken}"
          },
          body: jsonEncode(userData.toJson()));
      if (response.statusCode == 200) {
        return UserData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserData> updateUserData(User userData) async {
    try {
      final response = await http.put(Uri.parse("${baseUrl}api/user/update"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer ${SharedPrefs().authToken}"
          },
          body: jsonEncode(userData.toJson()));
      if (response.statusCode == 200) {
        return UserData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
