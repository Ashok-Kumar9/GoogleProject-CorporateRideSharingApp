// To parse this JSON data, do
//
//     final vehicle = vehicleFromJson(jsonString);

import 'dart:convert';

Vehicle vehicleFromJson(String str) => Vehicle.fromJson(json.decode(str));

String vehicleToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle {
  Vehicle({
    required this.message,
    required this.vehicle,
  });

  String message;
  VehicleClass vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    message: json["message"],
    vehicle: VehicleClass.fromJson(json["vehicle"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "vehicle": vehicle.toJson(),
  };
}

class VehicleClass {
  VehicleClass({
    this.vehicleId,
    this.vehicleType,
    this.vehicleName,
    this.vehicleDetails,
    this.vehicleNumber,
    this.maxCapacity,
  });

  String? vehicleId;
  String? vehicleType;
  String? vehicleName;
  String? vehicleDetails;
  String? vehicleNumber;
  int? maxCapacity;

  factory VehicleClass.fromJson(Map<String, dynamic> json) => VehicleClass(
    vehicleId: json["vehicleId"],
    vehicleType: json["vehicleType"],
    vehicleName: json["vehicleName"],
    vehicleDetails: json["vehicleDetails"],
    vehicleNumber: json["vehicleNumber"],
    maxCapacity: json["maxCapacity"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "vehicleType": vehicleType,
    "vehicleName": vehicleName,
    "vehicleDetails": vehicleDetails,
    "vehicleNumber": vehicleNumber,
    "maxCapacity": maxCapacity,
  };
}
