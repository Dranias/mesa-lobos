import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../managers/roles_manager.dart';

/// Flujo de la Vidente: se asigna a un jugador y cada noche observa a otro.
class VidenteFlow {
  final int? videnteIndex; // quién es la vidente
  final int? objetivoIndex; // a quién observa en la noche actual
  final bool videnteAsignada; // ya se asignó la vidente
  final bool objetivoAsignado; // ya observó a alguien esta noche

  VidenteFlow({
    this.videnteIndex,
    this.objetivoIndex,
    this.videnteAsignada = false,
    this.objetivoAsignado = false,
  });

  factory VidenteFlow.reset() => VidenteFlow();

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
}

/// Asigna el rol de Vidente a un jugador.
VidenteFlow assignVidente({
  required int index,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Rol Function(String nombre) resolverRol,
  required BuildContext context,
}) {
  final videnteRol = resolverRol('Vidente');
  rolesAsignados[index] = videnteRol;

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('${jugadores[index]} es la Vidente')));

  return VidenteFlow(videnteIndex: index, videnteAsignada: true);
}

/// La Vidente observa la carta de otro jugador.
VidenteFlow observarJugador({
  required int index,
  required int videnteIndex,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required BuildContext context,
}) {
  final rolObservado = rolesAsignados[index];
  final mensaje = rolObservado != null
      ? 'La Vidente observa a ${jugadores[index]} y ve que es ${rolObservado.nombre}'
      : 'La Vidente observa a ${jugadores[index]} pero aún no tiene rol asignado';

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(top: 80, left: 16, right: 16),
    ),
  );

  return VidenteFlow(
    videnteIndex: videnteIndex,
    objetivoIndex: index,
    videnteAsignada: true,
    objetivoAsignado: true,
  );
}
