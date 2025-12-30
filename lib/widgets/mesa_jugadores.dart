import 'dart:math';
import 'package:flutter/material.dart';
import '../data/roles.dart';

/// Muestra a los jugadores en círculo y maneja las selecciones según el rol que “despierta”.
/// No contiene lógica de negocio: delega en callbacks para Cupido, Niño Salvaje y roles genéricos.
class MesaJugadores extends StatelessWidget {
  final List<String> jugadores;
  final Map<int, Rol> rolesAsignados;

  // Rol que está activo en el paso actual de la narración (ej. 'Cupido', 'Niño Salvaje', 'Lobo Feroz', etc.)
  final String? rolActivo;

  // Estado visual para Cupido
  final int? cupidoIndex;
  final int? parejaIndex;
  final bool cupidoAsignado;
  final bool parejaAsignada;

  // Estado visual para Niño Salvaje
  final int? ninoSalvajeIndex;
  final int? modeloIndex;
  final bool ninoSalvajeAsignado;
  final bool modeloAsignado;

  // Callbacks de negocio (implementados en mesa_screen usando managers)
  final void Function(int index) onAsignarCupido;
  final void Function(int index) onSeleccionarPareja;
  final void Function(int index) onAsignarNino;
  final void Function(int index) onSeleccionarModelo;
  final void Function(int index, String nombreRol) onAsignarRolGenerico;

  const MesaJugadores({
    super.key,
    required this.jugadores,
    required this.rolesAsignados,
    required this.rolActivo,
    required this.cupidoIndex,
    required this.parejaIndex,
    required this.cupidoAsignado,
    required this.parejaAsignada,
    required this.ninoSalvajeIndex,
    required this.modeloIndex,
    required this.ninoSalvajeAsignado,
    required this.modeloAsignado,
    required this.onAsignarCupido,
    required this.onSeleccionarPareja,
    required this.onAsignarNino,
    required this.onSeleccionarModelo,
    required this.onAsignarRolGenerico,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final centerY = constraints.maxHeight / 2;
        final radius = min(centerX, centerY) - 90; // margen para cartas

        return Stack(
          children: List.generate(jugadores.length, (index) {
            final jugador = jugadores[index];
            final rolAsignado = rolesAsignados[index];

            // posición en círculo (empezando arriba)
            final angle = -pi / 2 + (2 * pi / jugadores.length) * index;
            final dx = centerX + radius * cos(angle);
            final dy = centerY + radius * sin(angle);

            return Positioned(
              left: dx - 45,
              top: dy - 60,
              child: GestureDetector(
                onTap: () {
                  if (rolActivo == null) return;

                  // Flujo especial: Cupido (selección única: Cupido y luego su pareja)
                  if (rolActivo == 'Cupido') {
                    if (!cupidoAsignado) {
                      onAsignarCupido(index);
                    } else if (!parejaAsignada) {
                      onSeleccionarPareja(index);
                    }
                    return;
                  }

                  // Flujo especial: Niño Salvaje (selección única: Niño y luego su modelo)
                  if (rolActivo == 'Niño Salvaje') {
                    if (!ninoSalvajeAsignado) {
                      onAsignarNino(index);
                    } else if (!modeloAsignado) {
                      onSeleccionarModelo(index);
                    }
                    return;
                  }

                  // Roles genéricos: asignar si aún no tiene rol
                  if (rolAsignado == null) {
                    onAsignarRolGenerico(index, rolActivo!);
                  }
                },
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          rolAsignado != null
                              ? rolAsignado.imagen
                              : 'assets/roles/carta.png',
                          width: 70,
                          height: 100,
                        ),

                        // Overlay para señalar al Cupido y su pareja (opcional y visual)
                        if (index == cupidoIndex)
                          Image.asset(
                            'assets/roles/cupido.png',
                            width: 28,
                            height: 28,
                          ),
                        if (index == parejaIndex)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Image.asset(
                              'assets/roles/cupido.png',
                              width: 24,
                              height: 24,
                            ),
                          ),

                        // Overlay para Niño Salvaje y su modelo (opcional y visual)
                        if (index == ninoSalvajeIndex)
                          Image.asset(
                            'assets/roles/nino_salvaje.png',
                            width: 28,
                            height: 28,
                          ),
                        if (index == modeloIndex)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Image.asset(
                              'assets/roles/nino_salvaje.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        jugador,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
