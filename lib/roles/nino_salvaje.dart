import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../utils/notificaciones.dart';

class NinoSalvajeFlow {
  final int? ninoIndex;
  final int? modeloIndex;
  final bool ninoAsignado;
  final bool modeloAsignado;
  final bool transformado;

  const NinoSalvajeFlow({
    this.ninoIndex,
    this.modeloIndex,
    this.ninoAsignado = false,
    this.modeloAsignado = false,
    this.transformado = false,    
  });

  factory NinoSalvajeFlow.reset() => const NinoSalvajeFlow();

  NinoSalvajeFlow copyWith({
    int? ninoIndex,
    int? modeloIndex,
    bool? ninoAsignado,
    bool? modeloAsignado,
    bool? transformado,
  }) {
    return NinoSalvajeFlow(
      ninoIndex: ninoIndex ?? this.ninoIndex,
      modeloIndex: modeloIndex ?? this.modeloIndex,
      ninoAsignado: ninoAsignado ?? this.ninoAsignado,
      modeloAsignado: modeloAsignado ?? this.modeloAsignado,
    );
  }

  bool isNino(int index) => ninoIndex != null && index == ninoIndex;
  bool isModelo(int index) => modeloIndex != null && index == modeloIndex;
}

NinoSalvajeFlow assignNinoSalvaje({
  required int index,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Rol Function(String nombre) resolverRol,
  required BuildContext context,
}) {
  final ninoRol = resolverRol('Niño Salvaje');
  rolesAsignados[index] = ninoRol;

  mostrarNotificacionArriba(context, '${jugadores[index]} es el Niño Salvaje');

  return NinoSalvajeFlow(ninoIndex: index, ninoAsignado: true);
}

NinoSalvajeFlow selectModelo({
  required int index,
  required NinoSalvajeFlow flow,
  required List<String> jugadores,
  required Map<String, List<String>> relaciones,
  required BuildContext context,
}) {
  relaciones['Niño Salvaje'] = [jugadores[flow.ninoIndex!], jugadores[index]];

  mostrarNotificacionArriba(context, 'El Niño Salvaje sigue como modelo a ${jugadores[index]}');

  return flow.copyWith(
    modeloIndex: index,
    modeloAsignado: true,
  );
}
