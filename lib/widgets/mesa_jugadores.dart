// widgets/mesa_jugadores.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/roles.dart';
import '../roles/cupido.dart';
import '../roles/nino_salvaje.dart';
import '../roles/vidente.dart';
import '../roles/lobos_comunes.dart';

class MesaJugadores extends StatelessWidget {
  final List<String> jugadores;
  final Map<int, Rol> rolesAsignados;
  final String? rolActivo;
  final void Function(int, String)? onAsignarRolGenerico;

  final CupidoFlow cupidoFlow;
  final NinoSalvajeFlow ninoFlow;
  final VidenteFlow videnteFlow;
  final LobosComunesFlow lobosFlow;
  final int? alguacilIndex;

  // 👇 nuevo: lista de muertos
  final Set<int> jugadoresMuertos;

  const MesaJugadores({
    super.key,
    required this.jugadores,
    required this.rolesAsignados,
    required this.rolActivo,
    this.onAsignarRolGenerico,
    required this.cupidoFlow,
    required this.ninoFlow,
    required this.videnteFlow,
    required this.lobosFlow,
    this.alguacilIndex,
    required this.jugadoresMuertos,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

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
    final startAngle = math.pi;
    final step = (2 * math.pi) / total;
    final angle = startAngle + step * index;

    const avatarRadius = 40.0;
    final x = cx + r * math.cos(angle) - avatarRadius;
    final y = cy + r * math.sin(angle) - avatarRadius;

    final nombre = jugadores[index];
    final rol = rolesAsignados[index];

    final isCupido = cupidoFlow.isCupido(index);
    final isEnamorado = cupidoFlow.isEnamorado(index);
    final isNino = ninoFlow.isNino(index);
    final isModelo = ninoFlow.isModelo(index);
    final isVidente = videnteFlow.isVidente(index);
    final esAlguacil = alguacilIndex == index;

    final muerto = jugadoresMuertos.contains(index); // 👈 nuevo

    // --- Avatar principal ---
    Widget avatar;
    if (muerto) {
      // 👇 si está muerto, mostrar muerto.png
      avatar = Image.asset(
        'assets/roles/muerto.png',
        width: avatarRadius * 2,
        height: avatarRadius * 2,
        fit: BoxFit.cover,
      );
    } else if (rol != null && rol.imagen.isNotEmpty) {
      avatar = Image.asset(
        rol.imagen,
        width: avatarRadius * 2,
        height: avatarRadius * 2,
        fit: BoxFit.cover,
      );
    } else {
      avatar = CircleAvatar(
        radius: avatarRadius,
        backgroundColor: Colors.blueGrey,
        child: Text(
          nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: muerto
            ? null // 👈 si está muerto, no responde
            : () {
                if (rolActivo != null) {
                  onAsignarRolGenerico?.call(index, rolActivo!);
                }
              },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                avatar,
                // Badges adicionales
                if (!isCupido && isEnamorado && !muerto)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Image.asset(
                      rolesAsignados.values
                          .firstWhere((r) => r.nombre == 'Cupido')
                          .imagen,
                      width: 28,
                      height: 28,
                    ),
                  ),
                if (!isNino && isModelo && !muerto)
                  Positioned(
                    left: -6,
                    bottom: -6,
                    child: Image.asset(
                      rolesAsignados.values
                          .firstWhere((r) => r.nombre == 'Niño Salvaje')
                          .imagen,
                      width: 28,
                      height: 28,
                    ),
                  ),
                if (isNino && !ninoFlow.transformado && !muerto)
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: Image.asset(
                      'assets/roles/nino_salvaje.png', // icono del niño salvaje
                      width: 28,
                      height: 28,
                    ),
                  ),
                if (isNino && ninoFlow.transformado && !muerto)
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: Image.asset(
                      'assets/roles/lobo_comun.png', // icono de lobo común
                      width: 28,
                      height: 28,
                    ),
                  ),
                if (esAlguacil && !muerto)
                  Positioned(
                    left: -6,
                    top: -6,
                    child: Image.asset(
                      'assets/roles/alguacil.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),
            Text(nombre),
            Text(
              muerto ? 'Muerto' : (rol?.nombre ?? 'Sin rol'),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
