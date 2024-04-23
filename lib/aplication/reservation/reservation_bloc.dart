import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nolatech/domain/Models/model_reservation.dart';
import 'package:flutter_nolatech/infrastructure/reposiroty_implementation/repository_implementation_reservation.dart';

part 'reservation_state.dart';
part 'reservation_event.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRepositoryImplementation reservationRepo =
      ReservationRepositoryImplementation();
  ReservationBloc() : super(ReservationState(data: List.empty())) {
    on<GetReservationEvent>(onGetReservationEvent);
    on<CreateReservationEvent>(onCreateReservationEvent);
    on<RemoveReservationEvent>(onRemoveReservationEvent);
  }

  onGetReservationEvent(
      GetReservationEvent event, Emitter<ReservationState> emit) async {
    final data = await reservationRepo.getReservation();
    data.sort((a, b) => b.dateRegister.compareTo(a.dateRegister));
    emit(ReservationState(data: data));
  }

  onCreateReservationEvent(
      CreateReservationEvent event, Emitter<ReservationState> emit) async {
    final countOfReservation = state.data
        .where((element) => element.date.day == event.reservation.date.day)
        .toList()
        .length;
    if (countOfReservation >= 9) return;
    await reservationRepo.createReservation(event.reservation);
    add(GetReservationEvent());
  }

  onRemoveReservationEvent(
      RemoveReservationEvent event, Emitter<ReservationState> emit) async {
    await reservationRepo.removeReservation(event.reservation);
    add(GetReservationEvent());
  }
}
