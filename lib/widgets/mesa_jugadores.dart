// widgets/mesa_jugadores.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/roles.dart';
import '../roles/cupido.dart'; // CupidoFlow y helpers
import '../roles/nino_salvaje.dart';

class MesaJugadores extends StatelessWidget {
  final List<String> jugadores;
  final Map<int, Rol> rolesAsignados;
  final String? rolActivo;

  // Callback de asignación disparada al tocar un jugador
  final void Function(int, String)? onAsignarRolGenerico;

  // Flujo de rol
  final CupidoFlow cupidoFlow;
  final NinoSalvajeFlow ninoFlow;

  const MesaJugadores({
    super.key,
    required this.jugadores,
    required this.rolesAsignados,
    required this.rolActivo,
    this.onAsignarRolGenerico,
    required this.cupidoFlow,
    required this.ninoFlow,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // Centro y radio relativos al espacio disponible
        final cx = width / 2;
        final cy = height / 2;
        final radius = math.min(width, height) * 0.38;

        return SizedBox.expand(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < jugadores.length; i++)
                _buildJugador(i, cx, cy, radius, jugadores.length),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJugador(int index, double cx, double cy, double r, int total) {
    // Distribución circular (arranque por la izquierda)
    final startAngle = math.pi;
    final step = (2 * math.pi) / total;
    final angle = startAngle + step * index;

    const avatarRadius = 28.0;
    final x = cx + r * math.cos(angle) - avatarRadius;
    final y = cy + r * math.sin(angle) - avatarRadius;

    final nombre = jugadores[index];
    final rol = rolesAsignados[index]?.nombre ?? 'Sin rol';

    final isCupido = cupidoFlow.isCupido(index);
    final isEnamorado = cupidoFlow.isEnamorado(index);

    final isNino = ninoFlow.isNino(index);
    final isModelo = ninoFlow.isModelo(index);

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () {
          if (rolActivo != null) {
            onAsignarRolGenerico?.call(index, rolActivo!);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar/carta
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Carta completa si es Cupido; avatar normal si no
                if (isCupido)
                  Image.asset(
                    'assets/roles/cupido.png',
                    width: avatarRadius * 2, // ocupa el diámetro
                    height: avatarRadius * 2,
                    fit: BoxFit.cover,
                  )
                else if (isNino)
                  Image.asset(
                    'assets/roles/nino_salvaje.png',
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    fit: BoxFit.cover,
                  )
                else
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),

                // Badge pequeño para enamorados (no para Cupido)
                if (!isCupido && isEnamorado)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Image.asset(
                      'assets/roles/cupido.png',
                      width: 16,
                      height: 16,
                    ),
                  ),

                if (!isNino && isModelo)
                  Positioned(
                    left: -2,
                    bottom: -2,
                    child: Image.asset(
                      'assets/roles/nino_salvaje.png',
                      width: 16,
                      height: 16,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),
            Text(nombre),
            Text(
              rol,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
