import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nolatech/aplication/reservation/reservation_bloc.dart';
import 'package:flutter_nolatech/domain/Models/model_reservation.dart';
import 'package:flutter_nolatech/presentation/screens/add_reservation.dart';
import 'package:flutter_nolatech/presentation/screens/reservation.dart';
import 'package:flutter_nolatech/presentation/screens/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ((context) => ReservationBloc()),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: const DashboardScreen(),
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/reservation': (context) => ReservationScreen(),
          '/add_reservation': (context) => AddReservationScreen(
                date: DateTime.now(),
                cloudines: 0,
                courtLimit: [],
              )
        },
      ),
    );
  }
}
