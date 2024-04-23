import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nolatech/aplication/reservation/reservation_bloc.dart';
import 'package:flutter_nolatech/domain/Models/model_court.dart';
import 'package:flutter_nolatech/domain/Models/model_reservation.dart';
import 'package:flutter_nolatech/presentation/screens/add_reservation.dart';
import 'package:flutter_nolatech/presentation/widgets/alert.dart';
import 'package:flutter_nolatech/presentation/widgets/list_reservation.dart';
import 'package:flutter_nolatech/presentation/widgets/mail_text.dart';
import 'package:weather/weather.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  bool limitAccept = false;
  int sumAccept = 0;
  double weatherF = 0;
  late List courtView = List.from(courtList);
  late ReservationBloc reservationBloc;
  late ReservationState state;

  late CalendarCarousel _calendarCarouselNoHeader;

  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: const Icon(
      Icons.person,
      color: Colors.pink,
    ),
  );

  late EventList<Event> _markedDateMap;

  @override
  void initState() {
    super.initState();
    courtView = List.from(courtList);
    context.read<ReservationBloc>().add(GetReservationEvent());

    _markedDateMap = EventList<Event>(events: {});

    for (var i = 0;
        i < context.read<ReservationBloc>().state.data.length;
        i++) {
      _markedDateMap.add(
        context.read<ReservationBloc>().state.data[i].date,
        Event(
          date: context.read<ReservationBloc>().state.data[i].date,
          title: context.read<ReservationBloc>().state.data[i].nameCourt,
          icon: _eventIcon,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    context.read<ReservationBloc>().add(GetReservationEvent());

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.black87,
      onDayPressed: (DateTime date, List<Event> events) {
        setState(() {
          _currentDate2 = date;
          courtView = List.from(courtList);

          for (var i = 0; i < courtList.length; i++) {
            if (courtView[i].limitReservation < 3) {
              courtView[i].limitReservation = 3;
              sumAccept = 0;
              limitAccept = false;
            }
          }

          events.forEach(
            (event) {
              for (var i = 0; i < courtView.length; i++) {
                if (event.title == courtView[i].name &&
                    courtView[i].limitReservation >= 1) {
                  courtView[i].limitReservation--;
                }
                if (courtView[i].limitReservation == 0) {
                  sumAccept++;
                }
                if (sumAccept == 9) {
                  limitAccept = true;
                }
              }
            },
          );
        });
      },
      selectedDayButtonColor: Colors.blue,
      selectedDayBorderColor: Colors.blue,
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: const TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 400.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: const CircleBorder(
        side: BorderSide(
          color: Colors.blue,
        ),
      ),
      markedDateCustomTextStyle: const TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: const TextStyle(
        color: Colors.black,
      ),
      todayButtonColor: Colors.blue,
      selectedDayTextStyle: const TextStyle(
        color: Colors.red,
      ),
      minSelectedDate: _currentDate.subtract(const Duration(days: 360)),
      maxSelectedDate: _currentDate.add(const Duration(days: 360)),
      prevDaysTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.red,
      ),
      inactiveDaysTextStyle: const TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservaciones'),
      ),
      body: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          courtView = List.from(courtList);
          _markedDateMap = EventList<Event>(events: {});
          courtView = List.from(courtList);

          for (var i = 0; i < state.data.length; i++) {
            _markedDateMap.add(
              state.data[i].date,
              Event(
                date: state.data[i].date,
                title: state.data[i].nameCourt,
                icon: _eventIcon,
              ),
            );
          }

          return SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //custom icon
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              _currentMonth,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            )),
                            TextButton(
                              child: const Text('Anterior'),
                              onPressed: () {
                                setState(() {
                                  _targetDateTime = DateTime(
                                      _targetDateTime.year,
                                      _targetDateTime.month - 1);
                                  _currentMonth =
                                      DateFormat.yMMM().format(_targetDateTime);
                                });
                              },
                            ),
                            TextButton(
                              child: const Text('Siguiente'),
                              onPressed: () {
                                setState(() {
                                  _targetDateTime = DateTime(
                                      _targetDateTime.year,
                                      _targetDateTime.month + 1);
                                  _currentMonth =
                                      DateFormat.yMMM().format(_targetDateTime);
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: height / 2.7,
                        child: _calendarCarouselNoHeader,
                      ), //
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 3.3,
                  child: ListView.builder(
                    itemCount: courtView.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListReservationWidget(
                        court: courtView[index],
                        index: index,
                        width: width,
                        height: height,
                      );
                    },
                  ),
                ),
                Container(
                  child: limitAccept == false
                      ? const MailTextWidget(
                          icon: Icons.warning,
                          value: 'Seleccione el día antes de reservar',
                          textStyle: TextStyle(
                            color: Colors.black,
                          ),
                        )
                      : const MailTextWidget(
                          icon: Icons.error,
                          value: 'Todas las canchas estan a su limite',
                          textStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                ),
                ElevatedButton(
                  onPressed: limitAccept == false
                      ? () {
                          alertBuilder(
                            context,
                            'Confirmar',
                            'Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(_currentDate2)}',
                          ).then((value) {
                            if (value == true) {
                              // Handle delete action here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReservationScreen(
                                    date: _currentDate2,
                                    cloudines: weatherF,
                                    courtLimit: courtList,
                                  ),
                                ),
                              );
                            } else {
                              print('cancel $value');
                            }
                          });
                        }
                      : null,
                  child: const Text('Reservar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



/*
_markedDateMap.add(
  _currentDate2,
  Event(
    date: _currentDate2,
    title: 'Event 4',
    icon: _eventIcon,
  ),
);
*/

    /*
    
    Calendario donde pueda agendar citas, y guardarlo en local, también poder ver el porcentaje de lluvia, del día seleccionado.
    */
/*
  WeatherFactory weatherFactory = WeatherFactory(
    '34a52743e62e06ffdd000e0ccab3524e',
    language: Language.SPANISH,
  );
*/

    /*
    FutureBuilder<Weather>(
      future: weatherFactory.currentWeatherByLocation(
          37.3891, 5.9845), // New York City coordinates
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Weather? weather = snapshot.data;
          return Text('Rain percentage: ${weather?.cloudiness}%');
        } else {
          return CircularProgressIndicator();
        }
      },
    ),
    */

    