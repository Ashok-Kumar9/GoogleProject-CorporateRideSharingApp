// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.message,
    required this.user,
  });

  String message;
  User user;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
      };
}

class User {
  User({
    this.userId,
    this.fullName,
    this.emailId,
    this.mobileNo,
    this.profileUrl,
    this.role,
    this.vehicleId,
  });

  String? userId;
  String? fullName;
  String? emailId;
  String? mobileNo;
  String? profileUrl;
  String? role;
  String? vehicleId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        fullName: json["fullName"],
        emailId: json["emailId"],
        mobileNo: json["mobileNo"],
        profileUrl: json["profileUrl"],
        role: json["role"],
        vehicleId: json["vehicleId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "fullName": fullName,
        "emailId": emailId,
        "mobileNo": mobileNo,
        "profileUrl": profileUrl,
        "role": role,
        "vehicleId": vehicleId,
      };
}
