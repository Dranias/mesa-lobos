// lib/roles/cupido.dart
import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../utils/notificaciones.dart';

class CupidoFlow {
  final int? cupidoIndex;
  final int? primerEnamoradoIndex;
  final int? segundoEnamoradoIndex;
  final bool cupidoAsignado;
  final bool primerEnamoradoAsignado;
  final bool segundoEnamoradoAsignado;

  const CupidoFlow({
    this.cupidoIndex,
    this.primerEnamoradoIndex,
    this.segundoEnamoradoIndex,
    this.cupidoAsignado = false,
    this.primerEnamoradoAsignado = false,
    this.segundoEnamoradoAsignado = false,
  });

  factory CupidoFlow.reset() => const CupidoFlow();

  CupidoFlow copyWith({
    int? cupidoIndex,
    int? primerEnamoradoIndex,
    int? segundoEnamoradoIndex,
    bool? cupidoAsignado,
    bool? primerEnamoradoAsignado,
    bool? segundoEnamoradoAsignado,
  }) {
    return CupidoFlow(
      cupidoIndex: cupidoIndex ?? this.cupidoIndex,
      primerEnamoradoIndex: primerEnamoradoIndex ?? this.primerEnamoradoIndex,
      segundoEnamoradoIndex: segundoEnamoradoIndex ?? this.segundoEnamoradoIndex,
      cupidoAsignado: cupidoAsignado ?? this.cupidoAsignado,
      primerEnamoradoAsignado: primerEnamoradoAsignado ?? this.primerEnamoradoAsignado,
      segundoEnamoradoAsignado: segundoEnamoradoAsignado ?? this.segundoEnamoradoAsignado,
    );
  }

  bool isCupido(int index) => cupidoIndex != null && index == cupidoIndex;
  bool isEnamorado(int index) =>
      (primerEnamoradoIndex != null && index == primerEnamoradoIndex) ||
      (segundoEnamoradoIndex != null && index == segundoEnamoradoIndex);
}

// Acciones de Cupido (como ya tienes)
CupidoFlow assignCupido({
  required int index,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Rol Function(String nombre) resolverRol,
  required BuildContext context,
}) {
  final cupidoRol = resolverRol('Cupido');
  rolesAsignados[index] = cupidoRol;

  mostrarNotificacionArriba(context, '${jugadores[index]} es Cupido');

  return CupidoFlow(cupidoIndex: index, cupidoAsignado: true);
}

CupidoFlow selectPrimerEnamorado({
  required int index,
  required CupidoFlow flow,
  required List<String> jugadores,
  required BuildContext context,
}) {
  mostrarNotificacionArriba(context, 'Cupido flecha a ${jugadores[index]} como primer enamorado');

  return flow.copyWith(
    primerEnamoradoIndex: index,
    primerEnamoradoAsignado: true,
  );
}

CupidoFlow selectSegundoEnamorado({
  required int index,
  required CupidoFlow flow,
  required List<String> jugadores,
  required Map<String, List<String>> relaciones,
  required BuildContext context,
}) {
  final enamorados = [
    jugadores[flow.primerEnamoradoIndex!],
    jugadores[index],
  ];
  relaciones['Enamorados'] = enamorados;

  mostrarNotificacionArriba(context, 'Pareja formada: ${enamorados[0]} ❤ ${enamorados[1]}');

  return flow.copyWith(
    segundoEnamoradoIndex: index,
    segundoEnamoradoAsignado: true,
  );
}

// ===== Helpers visuales para la mesa =====

/// Renderiza la “carta completa” si el índice es Cupido; si no,
/// el avatar normal con badge pequeño en enamorados.
/// - cardAsset: imagen completa de carta (e.g. assets/roles/cupido.png)
/// - badgeAsset: ícono pequeño (e.g. corazón). Puedes usar el mismo asset si aún no tienes corazón.
Widget buildCupidoAvatar({
  required CupidoFlow flow,
  required int index,
  required String nombre,
  double avatarRadius = 28.0,
  String cardAsset = 'assets/roles/cupido.png',
  String badgeAsset = 'assets/roles/cupido.png', // cambia a corazón cuando lo tengas
}) {
  final isCup = flow.isCupido(index);
  final isLove = flow.isEnamorado(index);

  return Stack(
    clipBehavior: Clip.none,
    children: [
      if (isCup)
        Image.asset(
          cardAsset,
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
      if (!isCup && isLove)
        Positioned(
          right: -2,
          top: -2,
          child: Image.asset(
            badgeAsset,
            width: 16,
            height: 16,
          ),
        ),
    ],
  );
}
