import 'package:flutter/material.dart';

/// Tarjeta del narrador:
/// - Muestra noche, paso y el rol que despierta.
/// - Indica instrucciones especiales para Cupido y Niño Salvaje.
/// - Deshabilita el botón "Siguiente" hasta completar sus selecciones únicas.
class NarradorCard extends StatelessWidget {
  final int nocheActual;
  final int pasoActual;
  final int totalPasos;
  final String? rolActivo;

  // Estado de Cupido
  final bool cupidoAsignado;
  final bool parejaAsignada;

  // Estado de Niño Salvaje
  final bool ninoSalvajeAsignado;
  final bool modeloAsignado;

  // Acción al avanzar
  final VoidCallback onNext;

  const NarradorCard({
    super.key,
    required this.nocheActual,
    required this.pasoActual,
    required this.totalPasos,
    required this.rolActivo,
    required this.cupidoAsignado,
    required this.parejaAsignada,
    required this.ninoSalvajeAsignado,
    required this.modeloAsignado,
    required this.onNext,
  });

  bool get _bloquearNext {
    // Cupido: requiere elegir Cupido y luego su pareja (una sola vez).
    final bloqueCupido = (rolActivo == 'Cupido') && (!cupidoAsignado || !parejaAsignada);
    // Niño Salvaje: requiere elegir Niño y luego su modelo (una sola vez).
    final bloqueNino = (rolActivo == 'Niño Salvaje') && (!ninoSalvajeAsignado || !modeloAsignado);
    return bloqueCupido || bloqueNino;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Noche $nocheActual',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Paso ${pasoActual + 1} de $totalPasos',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (rolActivo != null)
              Text(
                'Despierta: $rolActivo',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

            // Instrucciones dinámicas
            const SizedBox(height: 8),
            if (rolActivo == 'Cupido' && !cupidoAsignado)
              const Text(
                'Selecciona quién será Cupido',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            if (rolActivo == 'Cupido' && cupidoAsignado && !parejaAsignada)
              const Text(
                'Selecciona con quién se vincula Cupido',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            if (rolActivo == 'Niño Salvaje' && !ninoSalvajeAsignado)
              const Text(
                'Selecciona quién será el Niño Salvaje',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            if (rolActivo == 'Niño Salvaje' && ninoSalvajeAsignado && !modeloAsignado)
              const Text(
                'Selecciona a quién admira el Niño Salvaje',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _bloquearNext ? null : onNext,
              icon: const Icon(Icons.navigate_next),
              label: Text(pasoActual < totalPasos - 1 ? 'Siguiente' : 'Amanece'),
            ),
          ],
        ),
      ),
    );
  }
}
