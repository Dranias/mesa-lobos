import 'package:flutter/material.dart';
import 'configuracion_jugadores.dart';
import 'instrucciones_screen.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hombres Lobo - Inicio')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/tittle.png'), // 👈 tu imagen de fondo
            fit: BoxFit.cover, // ajusta la imagen al tamaño de la pantalla
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido a la Aldea',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 👈 texto en blanco para que contraste
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ConfiguracionJugadoresScreen(),
                    ),
                  );
                },
                child: const Text('Crear partida'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InstruccionesScreen(),
                    ),
                  );
                },
                child: const Text('Instrucciones'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
