import 'package:flutter/material.dart';
import 'package:flutter_nolatech/domain/Models/model_court.dart';
import 'package:flutter_nolatech/presentation/widgets/alert.dart';
import 'package:flutter_nolatech/presentation/widgets/alert_view.dart';
import 'package:weather/weather.dart';

class ListReservationWidget extends StatelessWidget {
  const ListReservationWidget({
    super.key,
    required this.court,
    required this.index,
    required this.width,
    required this.height,
  });

  final Court court;
  final int index;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    WeatherFactory weatherFactory = WeatherFactory(
      '34a52743e62e06ffdd000e0ccab3524e',
      language: Language.SPANISH,
    );
    late double weatherF;
    // print('indezzz $index');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,

      margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      // color: Colors.amberAccent,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width / 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text('Cancha: '),
                            Text(
                              court.name,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text('Reservaciones: '),
                            Text(
                              '${court.limitReservation}',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<Weather>(
                        future: weatherFactory.currentWeatherByLocation(
                            court.latitude,
                            court.longitude), // New York City coordinates
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: const Color.fromRGBO(158, 186, 219, 1),
                        child: const Icon(
                          Icons.visibility,
                          color: Color.fromARGB(255, 106, 211, 225),
                        ),
                        onPressed: () {
                          alertViewBuilder(
                            context,
                            height,
                            court.name,
                            court.location,
                            court.latitude,
                            court.longitude,
                            court.limitReservation,
                            weatherF,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
