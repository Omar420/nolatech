import 'dart:convert';

import 'package:flutter_nolatech/domain/Models/model_reservation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationDataSoruce {
  createReservation(Reservation reservation) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final json = reservation.toJson();
      final prevValues = await getReservation();

      prevValues.add(jsonEncode(json));

      await prefs.setStringList('listKey', prevValues);
      print(reservation);

      return reservation;
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> getReservation() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String> listReservation =
          prefs.getStringList('listKey') ?? List.empty(growable: true);

      return listReservation;
    } catch (e) {
      return List.empty();
    }
  }

  removeReservation(Reservation reservation) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final json = reservation.toJson();
      final listReservation = await getReservation();

      listReservation.remove(jsonEncode(json));

      await prefs.remove('listKey');

      await prefs.setStringList('listKey', listReservation);

      return reservation;
    } catch (e) {
      return false;
    }
  }
}
