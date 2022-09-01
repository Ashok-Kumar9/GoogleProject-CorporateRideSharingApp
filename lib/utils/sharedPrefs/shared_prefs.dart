import 'package:shared_preferences/shared_preferences.dart';

class PrefsConstants {
  static const String isLoggedIn = 'isLoggedIn';
  static const String phoneNumber = 'phoneNumber';
  static const String indexOfScreenWhereUserLeft = 'indexOfScreenWhereUserLeft';
  static const String authToken = 'authToken';
  static const String userRole = 'userRole';

  static const String userID = 'userID';
  static const String emailID = 'emailID';
  static const String fullName = 'fullName';
}

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  void clearSharedPrefs() {
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

  int get indexOfScreenWhereUserLeft =>
      _sharedPrefs.getInt(PrefsConstants.indexOfScreenWhereUserLeft) ?? 0;

  set indexOfScreenWhereUserLeft(int value) =>
      _sharedPrefs.setInt(PrefsConstants.indexOfScreenWhereUserLeft, value);

  String get authToken =>
      _sharedPrefs.getString(PrefsConstants.authToken) ?? "";

  set authToken(String value) =>
      _sharedPrefs.setString(PrefsConstants.authToken, value);


  String get userRole =>
      _sharedPrefs.getString(PrefsConstants.userRole) ?? "PASSENGER";

  set userRole(String value) =>
      _sharedPrefs.setString(PrefsConstants.userRole, value);
}
