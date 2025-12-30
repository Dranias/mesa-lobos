import 'package:flutter/material.dart';

/// Tarjeta del narrador:
/// - Muestra noche, paso y el rol que despierta.
/// - Indica instrucciones especiales para Cupido, Niño Salvaje, Vidente y Hombres Lobo Comunes.
/// - Deshabilita el botón "Siguiente" según el rol activo y su estado.
class NarradorCard extends StatelessWidget {
  final int nocheActual;
  final int pasoActual;
  final int totalPasos;
  final String rolActivo;

  // Cupido
  final bool cupidoAsignado;
  final bool primerEnamoradoAsignado;
  final bool segundoEnamoradoAsignado;

  // Niño Salvaje
  final bool ninoAsignado;
  final bool modeloAsignado;

  // Vidente
  final bool videnteAsignada;
  final bool objetivoAsignado;

  // Hombres Lobo Comunes
  final int cantidadLobos;        // número de lobos que deben asignarse
  final int lobosSeleccionados;   // cuántos lobos ya se han marcado
  final bool victimaAsignada;     // si ya eligieron víctima esa noche

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
    required this.videnteAsignada,
    required this.objetivoAsignado,
    required this.cantidadLobos,
    required this.lobosSeleccionados,
    required this.victimaAsignada,
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
    if (rolActivo == 'Vidente') {
      return !videnteAsignada || !objetivoAsignado;
    }
    if (rolActivo == 'Hombres Lobo Comunes') {
      // Primera noche: bloquear hasta que se seleccionen todos los lobos
      if (lobosSeleccionados < cantidadLobos) return true;
      // Noches siguientes: bloquear hasta que se elija víctima
      return !victimaAsignada;
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

            // Hombres Lobo Comunes
            if (rolActivo == 'Hombres Lobo Comunes' &&
                lobosSeleccionados < cantidadLobos)
              Text('Selecciona lobo ${lobosSeleccionados + 1} de $cantidadLobos'),
            if (rolActivo == 'Hombres Lobo Comunes' &&
                lobosSeleccionados >= cantidadLobos &&
                !victimaAsignada)
              const Text('Los lobos eligen a una víctima esta noche'),

            // Cupido
            if (rolActivo == 'Cupido' && !cupidoAsignado)
              const Text(
                'Cupido despierta y se revela (Selecciona al jugador que será Cupido)',
              ),
            if (rolActivo == 'Cupido' &&
                cupidoAsignado &&
                !primerEnamoradoAsignado)
              const Text('Cupido selecciona al primer enamorado'),
            if (rolActivo == 'Cupido' &&
                primerEnamoradoAsignado &&
                !segundoEnamoradoAsignado)
              const Text('Cupido selecciona al segundo enamorado'),

            // Niño Salvaje
            if (rolActivo == 'Niño Salvaje' && !ninoAsignado)
              const Text(
                'El Niño Salvaje despierta y se revela (Selecciona al jugador que será el Niño Salvaje)',
              ),
            if (rolActivo == 'Niño Salvaje' &&
                ninoAsignado &&
                !modeloAsignado)
              const Text('El Niño Salvaje elige a un modelo a seguir'),

            // Vidente
            if (rolActivo == 'Vidente' && !videnteAsignada)
              const Text(
                'La Vidente despierta y se revela (Selecciona al jugador que será la Vidente)',
              ),
            if (rolActivo == 'Vidente' &&
                videnteAsignada &&
                !objetivoAsignado)
              const Text('La Vidente observa la carta de un jugador'),

            const SizedBox(height: 12),
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
