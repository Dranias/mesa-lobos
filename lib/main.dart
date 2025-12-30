import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/configuracion_jugadores.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar orientación vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConfiguracionJugadoresScreen(),
    );
  }
}
