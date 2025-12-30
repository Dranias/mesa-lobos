import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../managers/roles_manager.dart';

/// Flujo genérico de lobos: guarda quiénes son lobos y sus acciones.
class LobosFlow {
  final List<int> lobosIndices;   // jugadores que son lobos
  final bool asignados;           // ya se asignaron los lobos
  final int? victimaIndex;        // víctima elegida en la noche

  LobosFlow({
    this.lobosIndices = const [],
    this.asignados = false,
    this.victimaIndex,
  });

  factory LobosFlow.reset() => LobosFlow();

  LobosFlow copyWith({
    List<int>? lobosIndices,
    bool? asignados,
    int? victimaIndex,
  }) {
    return LobosFlow(
      lobosIndices: lobosIndices ?? this.lobosIndices,
      asignados: asignados ?? this.asignados,
      victimaIndex: victimaIndex ?? this.victimaIndex,
    );
  }
}

/// Helper para saber si un rol es de tipo lobo.
bool esRolDeLobo(String rol) {
  return rol == 'Hombres Lobo Comunes' ||
         rol == 'Lobo Feroz' ||
         rol == 'Infecto Padre de todos los Lobos' ||
         rol == 'Hombre Lobo Albino' ||
         rol == 'Perro Lobo';
}

/// Asigna a un jugador como lobo (según el rol específico).
LobosFlow assignLobo({
  required int index,
  required String nombreRol,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Rol Function(String nombre) resolverRol,
  required LobosFlow flow,
  required BuildContext context,
}) {
  final rol = resolverRol(nombreRol);
  rolesAsignados[index] = rol;

  final nuevosLobos = [...flow.lobosIndices, index];

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${jugadores[index]} es $nombreRol')),
  );

  return flow.copyWith(lobosIndices: nuevosLobos, asignados: true);
}

/// Los lobos eligen a una víctima en la noche.
LobosFlow elegirVictima({
  required int index,
  required List<String> jugadores,
  required LobosFlow flow,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Los lobos devoran a ${jugadores[index]}')),
  );

  return flow.copyWith(victimaIndex: index);
}

/// Convierte al resto de jugadores en Aldeanos una vez que los lobos fueron asignados.
void finalizarAsignacionLobos({
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required List<Rol?> catalogo,
}) {
  for (int i = 0; i < jugadores.length; i++) {
    if (rolesAsignados[i] == null) {
      final aldeano = resolveRolByName('Aldeano', catalogo);
      rolesAsignados[i] = aldeano;
    }
  }
}
