import 'package:corporate_ride_sharing/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  void clearSharedPrefs(){
    _sharedPrefs.clear();
  }

  bool get isLoggedIn =>
      _sharedPrefs.getBool(PrefsConstants.isLoggedIn) ?? false;

  set isLoggedIn(bool value) =>
      _sharedPrefs.setBool(PrefsConstants.isLoggedIn, value);

  String get phoneNumber =>
      _sharedPrefs.getString(PrefsConstants.phoneNumber) ?? "";

  set phoneNumber(String value) =>
      _sharedPrefs.setString(PrefsConstants.phoneNumber, value);
}
