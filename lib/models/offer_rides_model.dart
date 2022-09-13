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
    this.id,
    this.availableSeats,
    this.currentPoint,
    this.boardingPoint,
    this.destinationPoint,
    this.userId,
    this.startingTime,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? rideStatus;
  String? id;
  int? availableSeats;
  Point? currentPoint;
  Point? boardingPoint;
  Point? destinationPoint;
  String? userId;
  DateTime? startingTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory RideOffer.fromJson(Map<String, dynamic> json) => RideOffer(
    rideStatus: json["rideStatus"],
    id: json["_id"],
    availableSeats: json["availableSeats"],
    currentPoint: Point.fromJson(json["currentPoint"]),
    boardingPoint: Point.fromJson(json["boardingPoint"]),
    destinationPoint: Point.fromJson(json["destinationPoint"]),
    userId: json["userId"],
    startingTime: DateTime.parse(json["startingTime"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "rideStatus": rideStatus,
    "_id": id,
    "availableSeats": availableSeats,
    "currentPoint": currentPoint?.toJson(),
    "boardingPoint": boardingPoint?.toJson(),
    "destinationPoint": destinationPoint?.toJson(),
    "userId": userId,
    "startingTime": startingTime?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Point {
  Point({
    required this.coordinates,
    this.id,
    this.type,
  });

  List<double> coordinates;
  String? id;
  String? type;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    id: json["_id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "_id": id,
    "type": type,
  };
}
