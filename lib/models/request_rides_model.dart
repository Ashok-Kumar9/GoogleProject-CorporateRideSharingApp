import 'dart:convert';

RequestRides requestRidesFromJson(String str) =>
    RequestRides.fromJson(json.decode(str));

String requestRidesToJson(RequestRides data) => json.encode(data.toJson());

class RequestRides {
  RequestRides({
    required this.message,
    required this.rideRequest,
  });

  String message;
  List<RideRequest> rideRequest;

  factory RequestRides.fromJson(Map<String, dynamic> json) => RequestRides(
        message: json["message"],
        rideRequest: List<RideRequest>.from(
            json["rideRequest"].map((x) => RideRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "rideRequest": List<dynamic>.from(rideRequest.map((x) => x.toJson())),
      };
}

class RideRequest {
  RideRequest(
      {this.rideStatus,
      this.seatsRequired,
      this.boardingPoint,
      this.destinationPoint,
      this.userId,
      this.startingTime});

  String? rideStatus;
  int? seatsRequired;
  Point? boardingPoint;
  Point? destinationPoint;
  String? userId;
  DateTime? startingTime;

  factory RideRequest.fromJson(Map<String, dynamic> json) => RideRequest(
        rideStatus: json["rideStatus"],
        seatsRequired: json["seatsRequired"],
        boardingPoint: Point.fromJson(json["boardingPoint"]),
        destinationPoint: Point.fromJson(json["destinationPoint"]),
        userId: json["userId"],
        startingTime: DateTime.parse(json["startingTime"]),
      );

  Map<String, dynamic> toJson() => {
        "rideStatus": rideStatus,
        "seatsRequired": seatsRequired,
        "boardingPoint": boardingPoint?.toJson(),
        "destinationPoint": destinationPoint?.toJson(),
        "userId": userId,
        "startingTime": startingTime?.toIso8601String(),
      };
}

class Point {
  Point({
    required this.coordinates,
    this.type = "Point",
  });

  List<double> coordinates;
  String type;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
      };
}
