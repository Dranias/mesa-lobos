import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../utils/notificaciones.dart';

class VidenteFlow {
  final int? videnteIndex;
  final int? objetivoIndex;
  final bool videnteAsignada;
  final bool objetivoAsignado;

  const VidenteFlow({
    this.videnteIndex,
    this.objetivoIndex,
    this.videnteAsignada = false,
    this.objetivoAsignado = false,
  });

  factory VidenteFlow.reset() => const VidenteFlow();

  VidenteFlow copyWith({
    int? videnteIndex,
    int? objetivoIndex,
    bool? videnteAsignada,
    bool? objetivoAsignado,
  }) {
    return VidenteFlow(
      videnteIndex: videnteIndex ?? this.videnteIndex,
      objetivoIndex: objetivoIndex ?? this.objetivoIndex,
      videnteAsignada: videnteAsignada ?? this.videnteAsignada,
      objetivoAsignado: objetivoAsignado ?? this.objetivoAsignado,
    );
  }

  bool isVidente(int index) => videnteIndex != null && index == videnteIndex;
  bool isObjetivo(int index) => objetivoIndex != null && index == objetivoIndex;
}

/// Asigna el rol de Vidente a un jugador (primera noche).
VidenteFlow assignVidente({
  required int index,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Rol Function(String nombre) resolverRol,
  required BuildContext context,
}) {
  final videnteRol = resolverRol('Vidente');
  rolesAsignados[index] = videnteRol;

  mostrarNotificacionArriba(context, '${jugadores[index]} es la Vidente');

  return VidenteFlow(videnteIndex: index, videnteAsignada: true);
}

/// La Vidente observa la carta de otro jugador (cada noche).
VidenteFlow observarJugador({
  required int index,
  required VidenteFlow flow,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Map<String, List<String>> relaciones,
  required BuildContext context,
}) {
  final rolObservado = rolesAsignados[index];
  final mensaje = rolObservado != null
      ? 'La Vidente observa a ${jugadores[index]} y ve que es ${rolObservado.nombre}'
      : 'La Vidente observa a ${jugadores[index]} pero aún no tiene rol asignado';

  // Guardamos el registro para el narrador en la pestaña lateral
  relaciones['Observaciones Vidente'] = [
    jugadores[flow.videnteIndex!],
    jugadores[index],
    rolObservado?.nombre ?? 'Sin rol'
  ];

  mostrarNotificacionArriba(context, mensaje);

  return flow.copyWith(
    objetivoIndex: index,
    objetivoAsignado: true,
  );
}

/// ===== Helper visual para la mesa =====
/// Muestra la carta completa si el jugador es la Vidente.
/// Ya no se dibuja badge en el observado.
Widget buildVidenteAvatar({
  required VidenteFlow flow,
  required int index,
  required String nombre,
  double avatarRadius = 28.0,
  String cardAsset = 'assets/roles/vidente.png',
}) {
  final isVid = flow.isVidente(index);

  return Stack(
    clipBehavior: Clip.none,
    children: [
      if (isVid)
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
    ],
  );
}
