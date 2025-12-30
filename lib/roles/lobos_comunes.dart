import 'package:flutter/material.dart';
import '../data/roles.dart';

class LobosComunesFlow {
  final List<int> lobosIndices;
  final bool asignados;
  final int? victimaIndex;

  const LobosComunesFlow({
    this.lobosIndices = const [],
    this.asignados = false,
    this.victimaIndex,
  });

  factory LobosComunesFlow.reset() => const LobosComunesFlow();

  LobosComunesFlow copyWith({
    List<int>? lobosIndices,
    bool? asignados,
    int? victimaIndex,
  }) {
    return LobosComunesFlow(
      lobosIndices: lobosIndices ?? this.lobosIndices,
      asignados: asignados ?? this.asignados,
      victimaIndex: victimaIndex ?? this.victimaIndex,
    );
  }

  bool isLobo(int index) => lobosIndices.contains(index);
  bool isVictima(int index) => victimaIndex != null && victimaIndex == index;
}

LobosComunesFlow assignLoboComun({
  required int index,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Rol Function(String nombre) resolverRol,
  required LobosComunesFlow flow,
  required BuildContext context,
}) {
  final rol = resolverRol('Hombres Lobo Comunes');
  rolesAsignados[index] = rol;

  final nuevosLobos = [...flow.lobosIndices, index];

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${jugadores[index]} es un Hombre Lobo Común')),
  );

  return flow.copyWith(lobosIndices: nuevosLobos, asignados: true);
}

LobosComunesFlow elegirVictimaComun({
  required int index,
  required List<String> jugadores,
  required LobosComunesFlow flow,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Los Hombres Lobo Comunes devoran a ${jugadores[index]}')),
  );

  return flow.copyWith(victimaIndex: index);
}

Widget buildLoboComunAvatar({
  required LobosComunesFlow flow,
  required int index,
  required String nombre,
  required Map<int, Rol> rolesAsignados,
  double avatarRadius = 28.0,
}) {
  final isLobo = flow.isLobo(index);

  if (isLobo) {
    return Image.asset(
      'assets/roles/lobo_comun.png',
      width: avatarRadius * 2,
      height: avatarRadius * 2,
      fit: BoxFit.cover,
    );
  }

  return CircleAvatar(
    radius: avatarRadius,
    backgroundColor: Colors.blueGrey,
    child: Text(
      nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}
