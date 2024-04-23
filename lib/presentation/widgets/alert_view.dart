import 'package:flutter/material.dart';

Future alertViewBuilder<bool>(
    BuildContext context,
    double height,
    String title,
    String location,
    double lat,
    double long,
    int limitReservation,
    double cloudiness) async {
  final response = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title), // DateFormat('dd-MM-yyy').format(item.date)
        content: SizedBox(
          height: height / 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text('Localidad: '),
                  Text(
                    '$location',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Latitud: '),
                  Text(
                    '$lat',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Longitud: '),
                  Text(
                    '$long',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Limite de Reservaciones: '),
                  Text(
                    '$limitReservation',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Probabilidad de lluvia: %'),
                  Text(
                    '$cloudiness',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Ok'),
            onPressed: () {
              return Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
  return response;
}
