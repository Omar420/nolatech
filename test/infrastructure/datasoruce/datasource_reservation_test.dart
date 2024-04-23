import 'dart:convert';

import 'package:flutter_nolatech/infrastructure/datasource/local/datasoruce_reservation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_nolatech/domain/Models/model_court.dart';
import 'package:flutter_nolatech/domain/Models/model_reservation.dart';

void main() {
  late ReservationDataSoruce reservationDataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = await SharedPreferences.getInstance();
    reservationDataSource = ReservationDataSoruce();
  });

  group('createReservation', () {
    test('should create a new reservation and save it to shared preferences',
        () async {
      final reservation = Reservation(
        nameCourt: 'Court 1',
        nameUser: 'John Doe',
        date: DateTime.now(),
        dateRegister: DateTime.now(),
        cloudiness: 0.5,
        court: Court(
          name: 'Court 1',
          latitude: 1.0,
          longitude: 1.0,
          value: 'canchab',
          limitReservation: 3,
          location: 'Barcelona',
        ),
      );

      final createdReservation =
          await reservationDataSource.createReservation(reservation);

      expect(createdReservation, reservation);

      final listReservation = await sharedPreferences.getStringList('listKey');
      final jsonReservation = jsonDecode(listReservation!.last);

      expect(jsonReservation, reservation.toJson());
    });

    test(
        'should throw an exception if there is an error saving the reservation',
        () async {
      final reservation = Reservation(
        nameCourt: 'Court 1',
        nameUser: 'John Doe',
        date: DateTime.now(),
        dateRegister: DateTime.now(),
        cloudiness: 0.5,
        court: Court(
          name: 'Court 1',
          latitude: 1.0,
          longitude: 1.0,
          value: 'canchab',
          limitReservation: 3,
          location: 'Barcelona',
        ),
      );

      expect(
        () async => await reservationDataSource.createReservation(reservation),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getReservation', () {
    test('should return an empty list if there are no reservations', () async {
      final listReservation = await reservationDataSource.getReservation();

      expect(listReservation, []);
    });

    test('should return a list of reservations', () async {
      final reservation1 = Reservation(
        nameCourt: 'Court 1',
        nameUser: 'John Doe',
        date: DateTime.now(),
        dateRegister: DateTime.now(),
        cloudiness: 0.5,
        court: Court(
          name: 'Court 1',
          latitude: 1.0,
          longitude: 1.0,
          value: 'canchab',
          limitReservation: 3,
          location: 'Barcelona',
        ),
      );

      final reservation2 = Reservation(
        nameCourt: 'Court 2',
        nameUser: 'John Doe',
        date: DateTime.now(),
        dateRegister: DateTime.now(),
        cloudiness: 0.5,
        court: Court(
          name: 'Cancha A',
          latitude: 1.0,
          longitude: 1.0,
          value: 'canchaa',
          limitReservation: 3,
          location: 'León',
        ),
      );

      await sharedPreferences.setStringList(
        'listKey',
        [
          jsonEncode(reservation1.toJson()),
          jsonEncode(reservation2.toJson()),
        ],
      );

      final listReservation = await reservationDataSource.getReservation();

      expect(listReservation, [
        jsonDecode(listReservation[0]) as Map<String, dynamic>,
        jsonDecode(listReservation[1]) as Map<String, dynamic>,
      ]);
    });
  });

  group('removeReservation', () {
    test('should remove a reservation from shared preferences', () async {
      final reservation = Reservation(
        nameCourt: 'Court 1',
        nameUser: 'John Doe',
        date: DateTime.now(),
        dateRegister: DateTime.now(),
        cloudiness: 0.5,
        court: Court(
          name: 'Court 1',
          latitude: 1.0,
          longitude: 1.0,
          value: 'canchab',
          limitReservation: 3,
          location: 'Barcelona',
        ),
      );

      await sharedPreferences.setStringList(
        'listKey',
        [jsonEncode(reservation.toJson())],
      );

      await reservationDataSource.removeReservation(reservation);

      final listReservation = await sharedPreferences.getStringList('listKey');

      expect(listReservation, []);
    });

    test('should return false if there is an error removing the reservation',
        () async {
      final reservation = Reservation(
        nameCourt: 'Court 1',
        nameUser: 'John Doe',
        date: DateTime.now(),
        dateRegister: DateTime.now(),
        cloudiness: 0.5,
        court: Court(
          name: 'Court 1',
          latitude: 1.0,
          longitude: 1.0,
          value: 'canchab',
          limitReservation: 3,
          location: 'Barcelona',
        ),
      );

      final result = await reservationDataSource.removeReservation(reservation);

      expect(result, false);
    });
  });
}
