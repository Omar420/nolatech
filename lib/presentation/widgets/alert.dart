import 'package:flutter/material.dart';

Future alertBuilder<bool>(
    BuildContext context, String title, String content) async {
  final response = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancelar'),
            onPressed: () {
              return Navigator.of(
                context,
              ).pop(false);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Aceptar'),
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
