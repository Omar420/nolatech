import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nolatech/aplication/reservation/reservation_bloc.dart';
import 'package:flutter_nolatech/domain/Models/model_reservation.dart';
import 'package:flutter_nolatech/presentation/widgets/alert.dart';
import 'package:intl/intl.dart' show DateFormat;

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.item,
    required this.index,
    required this.width,
    required this.height,
  });

  final Reservation item;
  final int index;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // print('indezzz $index');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 5, left: 16, right: 16, top: 10),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0), //                 <--- border radius here
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        // color: Colors.amberAccent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width / 2.5,
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
                              item.nameCourt,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text('Reservado por: '),
                            Text(
                              item.nameUser,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text('Fecha: '),
                            Text(
                              DateFormat('dd-MM-yyy').format(item.date),
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
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
                          Icons.delete,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          alertBuilder(
                            context,
                            'Confirmar',
                            'Desea eliminar la reservación?',
                          ).then((value) {
                            if (value == true) {
                              context.read<ReservationBloc>().add(
                                  RemoveReservationEvent(reservation: item));
                              // Handle delete action here
                              print('acept $value');
                            } else {
                              print('cancel $value');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pronostico lluvia: %'),
                Text(
                  '${item.cloudiness}',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
