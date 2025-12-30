import 'package:flutter/material.dart';

/// Tarjeta del narrador:
/// - Muestra noche, paso y el rol que despierta.
/// - Indica instrucciones especiales para Cupido y Niño Salvaje.
/// - Deshabilita el botón "Siguiente" hasta completar sus selecciones únicas.
class NarradorCard extends StatelessWidget {
  final int nocheActual;
  final int pasoActual;
  final int totalPasos;
  final String rolActivo;

  //Cupido
  final bool cupidoAsignado;
  final bool primerEnamoradoAsignado;
  final bool segundoEnamoradoAsignado;

  //Niño Salvaje
  final bool ninoAsignado;
  final bool modeloAsignado;

  final VoidCallback onNext;

  const NarradorCard({
    super.key,
    required this.nocheActual,
    required this.pasoActual,
    required this.totalPasos,
    required this.rolActivo,
    required this.cupidoAsignado,
    required this.primerEnamoradoAsignado,
    required this.segundoEnamoradoAsignado,
    required this.ninoAsignado,
    required this.modeloAsignado,
    required this.onNext,
  });

  bool get _bloquearNext {
    if (rolActivo == 'Cupido') {
      return !cupidoAsignado ||
          !primerEnamoradoAsignado ||
          !segundoEnamoradoAsignado;
    }
    if (rolActivo == 'Niño Salvaje') {
      return !ninoAsignado || !modeloAsignado;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Noche $nocheActual'),
            Text('Paso ${pasoActual + 1} de $totalPasos'),
            Text('Despierta: $rolActivo'),

            //Texto para cupido
            if (rolActivo == 'Cupido' && !cupidoAsignado)
              const Text(
                'Cupido despierta y se revela (Selecciona al jugador que será cupido)',
              ),
            if (rolActivo == 'Cupido' &&
                cupidoAsignado &&
                !primerEnamoradoAsignado)
              const Text('Cupido selecciona al primer enamorado'),
            if (rolActivo == 'Cupido' &&
                primerEnamoradoAsignado &&
                !segundoEnamoradoAsignado)
              const Text('Cupido selecciona al segundo enamorado'),

            //Texto para niño salvaje
            if (rolActivo == 'Niño Salvaje' && !ninoAsignado)
              const Text(
                'El Niño Salvaje despierta y se revela (Selecciona al jugador que será el Niño Salvaje)',
              ),
            if (rolActivo == 'Niño Salvaje' && ninoAsignado && !modeloAsignado)
              const Text('El Niño Salvaje elige a un modelo a seguir'),

            ElevatedButton(
              onPressed: _bloquearNext ? null : onNext,
              child: Text(
                pasoActual < totalPasos - 1 ? 'Siguiente' : 'Amanece',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
