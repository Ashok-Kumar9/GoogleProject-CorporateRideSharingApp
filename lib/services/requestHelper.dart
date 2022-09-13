import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(String url) async {
    var uri = Uri.parse(url);
    http.Response response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodeData = jsonDecode(data);
        return decodeData;
      } else {
        return "Error";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
