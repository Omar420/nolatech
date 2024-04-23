import 'dart:ui';

import 'package:flutter_nolatech/domain/Models/model_court.dart';

class Reservation {
  // int id;
  String nameCourt;
  DateTime date;
  DateTime dateRegister;
  String nameUser;
  double cloudiness;
  Court court;

  Reservation({
    // required this.id,
    required this.nameCourt,
    required this.date,
    required this.dateRegister,
    required this.nameUser,
    required this.cloudiness,
    required this.court,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'nameCourt': nameCourt,
      'date': date.toIso8601String(),
      'dateRegister': dateRegister.toIso8601String(),
      'nameUser': nameUser,
      'cloudiness': cloudiness,
      'court': court.toJson()
    };
  }

  factory Reservation.formJson(Map<String, dynamic> data) {
    return Reservation(
      // id: data['id'],
      nameCourt: data['nameCourt'],
      date: DateTime.parse(data['date']),
      dateRegister: DateTime.parse(data['dateRegister']),
      nameUser: data['nameUser'],
      cloudiness: data['cloudiness'],
      court: Court.formJson(data['court']),
    );
  }
}
