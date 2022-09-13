class PlacePrediction {
  late String secondary_text;
  late String main_text;
  late String place_id;

  PlacePrediction(this.secondary_text, this.main_text, this.place_id);

  PlacePrediction.fromJSON(Map<String, dynamic> json) {
    place_id = json['place_id'];
    main_text = json['structured_formatting']['main_text'];
    secondary_text = json['structured_formatting']['secondary_text'];
  }
}
