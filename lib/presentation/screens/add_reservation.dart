import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nolatech/aplication/reservation/reservation_bloc.dart';
import 'package:flutter_nolatech/domain/Models/model_court.dart';
import 'package:flutter_nolatech/domain/Models/model_reservation.dart';
import 'package:flutter_nolatech/presentation/screens/dashboard.dart';
import 'package:flutter_nolatech/presentation/widgets/alert.dart';
import 'package:flutter_nolatech/presentation/widgets/mail_text.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather/weather.dart';

List<DropdownMenuItem<String>> menuItems = [];

class AddReservationScreen extends StatefulWidget {
  final DateTime date;
  final double cloudines;
  final List courtLimit;
  const AddReservationScreen({
    super.key,
    required this.date,
    required this.cloudines,
    required this.courtLimit,
  });

  @override
  _AddReservationScreenState createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  WeatherFactory weatherFactory = WeatherFactory(
    '34a52743e62e06ffdd000e0ccab3524e',
    language: Language.SPANISH,
  );

  String nameValue = '';
  bool reservationAccept = false;
  late Court selectCourt;
  late List courtLimit;
  late double weatherF;

  @override
  void initState() {
    super.initState();
    courtLimit = widget.courtLimit;
    for (var i = 0; i < courtLimit.length; i++) {
      if (courtLimit[i].limitReservation == 0) {
        courtLimit.remove(courtLimit[i]);
      }
    }
    selectCourt = courtLimit[0];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Reservación'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: width,
        height: height,
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Fecha: '),
                      Text(
                        DateFormat('yyyy-MM-dd').format(widget.date),
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<Weather>(
                    future: weatherFactory.currentWeatherByLocation(
                        selectCourt.latitude,
                        selectCourt.longitude), // New York City coordinates
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Weather? weather = snapshot.data;
                        weatherF = weather!.cloudiness!;
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Text('Probabilidad de lluvia: %'),
                              Text(
                                '${weather!.cloudiness}',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Seleccionar Cancha: '),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: width / 2,
                    child: DropdownButton(
                      value: selectCourt.value,
                      items: courtLimit.map((e) {
                        return DropdownMenuItem<String>(
                          value: e.value,
                          child: Text(e.name),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          print('object $value');
                          for (var i = 0; i < courtList.length; i++) {
                            if (value == courtList[i].value) {
                              selectCourt = courtList[i];
                            }
                          }
                          print('Select ${selectCourt.value}');
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nombre Personal: '),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: width / 2,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Nombre',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          nameValue = value;
                          print('objectsss $nameValue');
                          nameValue.isEmpty
                              ? reservationAccept = false
                              : reservationAccept = true;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 50,
              child: ElevatedButton(
                onPressed: reservationAccept == false
                    ? null
                    : () async {
                        await alertBuilder(
                          context,
                          'Confirmar',
                          'Confirmar la Reservación ',
                        ).then((value) async {
                          if (value == true) {
                            var save = Reservation(
                              nameCourt: selectCourt.name,
                              date: widget.date,
                              dateRegister: DateTime.now(),
                              nameUser: nameValue,
                              cloudiness: weatherF,
                              court: selectCourt,
                            );
                            // Handle delete action here

                            context
                                .read<ReservationBloc>()
                                .add(CreateReservationEvent(reservation: save));
                            await Navigator.pushNamed(context, '/dashboard');
                            print("End Trigger");
                          } else {
                            print('cancel $value');
                          }
                        });
                      },
                child: const Text('Reservar'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: reservationAccept == true
                  ? const MailTextWidget(
                      icon: Icons.warning,
                      value: 'Verifique que los datos sean correctos',
                      textStyle: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  : const MailTextWidget(
                      icon: Icons.error,
                      value: 'Debe llenar el campo de "Nombre Personal"',
                      textStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
