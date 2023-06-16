import 'dart:convert';

OfferRides offerRidesFromJson(String str) => OfferRides.fromJson(json.decode(str));

String offerRidesToJson(OfferRides data) => json.encode(data.toJson());

class OfferRides {
  OfferRides({
    required this.message,
    required this.rideOffer,
  });

  String message;
  List<RideOffer> rideOffer;

  factory OfferRides.fromJson(Map<String, dynamic> json) => OfferRides(
    message: json["message"],
    rideOffer: List<RideOffer>.from(json["rideOffer"].map((x) => RideOffer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "rideOffer": List<dynamic>.from(rideOffer.map((x) => x.toJson())),
  };
}

class RideOffer {
  RideOffer({
    this.rideStatus,
    this.availableSeats,
    this.currentPoint,
    this.boardingPoint,
    this.destinationPoint,
    this.userId,
    this.startingTime,
  });

  String? rideStatus;
  int? availableSeats;
  Point? currentPoint;
  Point? boardingPoint;
  Point? destinationPoint;
  String? userId;
  DateTime? startingTime;

  factory RideOffer.fromJson(Map<String, dynamic> json) => RideOffer(
    rideStatus: json["rideStatus"],
    availableSeats: json["availableSeats"],
    currentPoint: Point.fromJson(json["currentPoint"]),
    boardingPoint: Point.fromJson(json["boardingPoint"]),
    destinationPoint: Point.fromJson(json["destinationPoint"]),
    userId: json["userId"],
    startingTime: DateTime.parse(json["startingTime"]),
  );

  Map<String, dynamic> toJson() => {
    "rideStatus": rideStatus,
    "availableSeats": availableSeats,
    "currentPoint": currentPoint?.toJson(),
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
  String? id;
  String type;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "type": type,
  };
}
