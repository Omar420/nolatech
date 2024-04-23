import 'package:flutter_nolatech/domain/Models/model_reservation.dart';

abstract class ReservationRepository {
  Future<List<Reservation>> getReservation();

  Future<Reservation> createReservation(Reservation data);

  Future<Reservation> removeReservation(Reservation data);
}
