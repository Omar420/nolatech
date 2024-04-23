part of 'reservation_bloc.dart';

sealed class ReservationEvent {}

class GetReservationEvent extends ReservationEvent {}

class CreateReservationEvent extends ReservationEvent {
  Reservation reservation;

  CreateReservationEvent({required this.reservation});
}

class RemoveReservationEvent extends ReservationEvent {
  Reservation reservation;

  RemoveReservationEvent({required this.reservation});
}
