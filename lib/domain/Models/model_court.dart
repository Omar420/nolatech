class Court {
  String name;
  String value;
  int limitReservation;
  String location;
  double latitude;
  double longitude;

  Court({
    required this.name,
    required this.value,
    required this.limitReservation,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'limitReservation': limitReservation,
      'location': location,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  factory Court.formJson(Map<String, dynamic> data) {
    return Court(
      // id: data['id'],
      name: data['name'],
      value: data['value'],
      limitReservation: data['limitReservation'],
      location: data['location'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }
}

List courtList = [
  Court(
    name: 'Cancha A',
    value: 'canchaa',
    limitReservation: 3,
    location: 'León',
    latitude: 42.5984,
    longitude: 5.5719,
  ),
  Court(
    name: 'Cancha B',
    value: 'canchab',
    limitReservation: 3,
    location: 'Sevilla',
    latitude: 37.3891,
    longitude: 5.9845,
  ),
  Court(
    name: 'Cancha C',
    value: 'canchac',
    limitReservation: 3,
    location: 'Barcelona',
    latitude: 41.3874,
    longitude: 2.1686,
  ),
];


/*
APIKEY: 34a52743e62e06ffdd000e0ccab3524e
*/