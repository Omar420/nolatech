import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nolatech/aplication/reservation/reservation_bloc.dart';
import 'package:flutter_nolatech/domain/Models/model_reservation.dart';
import 'package:flutter_nolatech/presentation/screens/reservation.dart';
import 'package:flutter_nolatech/presentation/widgets/card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    context.read<ReservationBloc>().add(GetReservationEvent());

    int _rainPercentage = 0;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 15,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationScreen(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Nolatech'),
      ),
      body: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          return Container(
            width: width,
            height: height,
            color: Colors.white,
            child: ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (BuildContext context, index) {
                return CardWidget(
                  item: state.data[index],
                  index: index,
                  width: width,
                  height: height - 140,
                );
              },
            ),
          );
        },
      ),
      /*
      Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
      */
    );
  }
}



/*
La lista debe mostrar el nombre de la cancha, la 
fecha y el nombre del usuario que realizó el agendamiento. También debe mostrar el 
porcentaje de probabilidad de lluvia para este día
*/

