import 'dart:convert';

import 'package:flutter_nolatech/domain/Models/model_reservation.dart';
import 'package:flutter_nolatech/domain/repository/reposiroty_reservation.dart';
import 'package:flutter_nolatech/infrastructure/datasource/local/datasoruce_reservation.dart';

Reservation parseDataSource(String data) {
  return Reservation.formJson(jsonDecode(data));
}

class ReservationRepositoryImplementation implements ReservationRepository {
  final ReservationDataSoruce dataSource = ReservationDataSoruce();

  @override
  Future<List<Reservation>> getReservation() async {
    try {
      final rawReservations = await dataSource.getReservation();
      final reservations = rawReservations.map(parseDataSource).toList();
      return reservations;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  @override
  Future<Reservation> createReservation(Reservation data) async {
    return await dataSource.createReservation(data);
  }

  @override
  Future<Reservation> removeReservation(Reservation data) async {
    return await dataSource.removeReservation(data);
  }
}
