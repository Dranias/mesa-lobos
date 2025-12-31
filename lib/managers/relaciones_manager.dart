import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../utils/notificaciones.dart';

/// Estado del flujo de Cupido (quién es Cupido y con quién se vincula).
class CupidoFlow {
  final int? cupidoIndex;
  final int? parejaIndex;
  final bool cupidoAsignado;
  final bool parejaAsignada;

  const CupidoFlow({
    this.cupidoIndex,
    this.parejaIndex,
    this.cupidoAsignado = false,
    this.parejaAsignada = false,
  });

  CupidoFlow copyWith({
    int? cupidoIndex,
    int? parejaIndex,
    bool? cupidoAsignado,
    bool? parejaAsignada,
  }) {
    return CupidoFlow(
      cupidoIndex: cupidoIndex ?? this.cupidoIndex,
      parejaIndex: parejaIndex ?? this.parejaIndex,
      cupidoAsignado: cupidoAsignado ?? this.cupidoAsignado,
      parejaAsignada: parejaAsignada ?? this.parejaAsignada,
    );
  }

  static CupidoFlow reset() => const CupidoFlow();
}

/// Estado del flujo de Niño Salvaje (quién es y a quién admira).
class NinoSalvajeFlow {
  final int? ninoIndex;
  final int? modeloIndex;
  final bool ninoAsignado;
  final bool modeloAsignado;

  const NinoSalvajeFlow({
    this.ninoIndex,
    this.modeloIndex,
    this.ninoAsignado = false,
    this.modeloAsignado = false,
  });

  NinoSalvajeFlow copyWith({
    int? ninoIndex,
    int? modeloIndex,
    bool? ninoAsignado,
    bool? modeloAsignado,
  }) {
    return NinoSalvajeFlow(
      ninoIndex: ninoIndex ?? this.ninoIndex,
      modeloIndex: modeloIndex ?? this.modeloIndex,
      ninoAsignado: ninoAsignado ?? this.ninoAsignado,
      modeloAsignado: modeloAsignado ?? this.modeloAsignado,
    );
  }

  static NinoSalvajeFlow reset() => const NinoSalvajeFlow();
}

/// Asigna Cupido a un jugador. Devuelve el estado actualizado del flujo.
/// - resolverRol: función para obtener el Rol por nombre desde tu catálogo (evita construir rutas de imagen manuales).
CupidoFlow assignCupido({
  required int index,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Map<String, List<String>> relaciones,
  required Rol Function(String nombre) resolverRol,
  BuildContext? context,
}) {
  final rolCupido = resolverRol('Cupido');
  rolesAsignados[index] = rolCupido;

  // No registramos relación aún; se hace al elegir la pareja.
  if (context != null) {
    mostrarNotificacionArriba(context, '${jugadores[index]} ahora es ${rolCupido.nombre}');
  }

  return CupidoFlow(
    cupidoIndex: index,
    parejaIndex: null,
    cupidoAsignado: true,
    parejaAsignada: false,
  );
}

/// Selecciona la pareja de Cupido (no puede ser él mismo). Devuelve el estado actualizado.
/// Actualiza relaciones['Cupido'] = [Cupido, Pareja].
CupidoFlow selectPareja({
  required int index,
  required int cupidoIndex,
  required List<String> jugadores,
  required Map<String, List<String>> relaciones,
  BuildContext? context,
}) {
  if (index == cupidoIndex) {
    // Ignorar si toca a sí mismo.
    return CupidoFlow(
      cupidoIndex: cupidoIndex,
      parejaIndex: null,
      cupidoAsignado: true,
      parejaAsignada: false,
    );
  }

  relaciones['Cupido'] = [
    jugadores[cupidoIndex],
    jugadores[index],
  ];

  if (context != null) {
    mostrarNotificacionArriba(context, 'Cupido (${jugadores[cupidoIndex]}) se vinculó con ${jugadores[index]}');
  }

  return CupidoFlow(
    cupidoIndex: cupidoIndex,
    parejaIndex: index,
    cupidoAsignado: true,
    parejaAsignada: true,
  );
}

/// Asigna Niño Salvaje a un jugador. Devuelve el estado actualizado.
/// - resolverRol: función para obtener el Rol por nombre desde tu catálogo.
NinoSalvajeFlow assignNinoSalvaje({
  required int index,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Map<String, List<String>> relaciones,
  required Rol Function(String nombre) resolverRol,
  BuildContext? context,
}) {
  final rolNino = resolverRol('Niño Salvaje');
  rolesAsignados[index] = rolNino;

  if (context != null) {
    mostrarNotificacionArriba(context, '${jugadores[index]} ahora es ${rolNino.nombre}');
  }

  return NinoSalvajeFlow(
    ninoIndex: index,
    modeloIndex: null,
    ninoAsignado: true,
    modeloAsignado: false,
  );
}

/// Selecciona el modelo del Niño Salvaje (no puede ser él mismo). Devuelve el estado actualizado.
/// Actualiza relaciones['Niño Salvaje'] = [Niño, Modelo].
NinoSalvajeFlow selectModelo({
  required int index,
  required int ninoIndex,
  required List<String> jugadores,
  required Map<String, List<String>> relaciones,
  BuildContext? context,
}) {
  if (index == ninoIndex) {
    return NinoSalvajeFlow(
      ninoIndex: ninoIndex,
      modeloIndex: null,
      ninoAsignado: true,
      modeloAsignado: false,
    );
  }

  relaciones['Niño Salvaje'] = [
    jugadores[ninoIndex],
    jugadores[index],
  ];

  if (context != null) {
    mostrarNotificacionArriba(context, 'Niño Salvaje (${jugadores[ninoIndex]}) eligió como modelo a ${jugadores[index]}');
  }

  return NinoSalvajeFlow(
    ninoIndex: ninoIndex,
    modeloIndex: index,
    ninoAsignado: true,
    modeloAsignado: true,
  );
}

/// Utilidad para resetear los flags de Cupido al salir del paso de Cupido.
CupidoFlow resetCupidoFlow() => CupidoFlow.reset();

/// Utilidad para resetear los flags de Niño Salvaje al salir del paso de Niño Salvaje.
NinoSalvajeFlow resetNinoSalvajeFlow() => NinoSalvajeFlow.reset();
