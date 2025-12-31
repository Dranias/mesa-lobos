import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../utils/notificaciones.dart';

class BrujaFlow {
  final int? brujaIndex;
  final bool brujaAsignada;

  final bool pocionVidaUsada;
  final int? pocionVidaObjetivo;

  final bool pocionMuerteUsada;
  final int? pocionMuerteObjetivo;

  const BrujaFlow({
    this.brujaIndex,
    this.brujaAsignada = false,
    this.pocionVidaUsada = false,
    this.pocionVidaObjetivo,
    this.pocionMuerteUsada = false,
    this.pocionMuerteObjetivo,
  });

  factory BrujaFlow.reset() => const BrujaFlow();

  BrujaFlow copyWith({
    int? brujaIndex,
    bool? brujaAsignada,
    bool? pocionVidaUsada,
    int? pocionVidaObjetivo,
    bool? pocionMuerteUsada,
    int? pocionMuerteObjetivo,
  }) {
    return BrujaFlow(
      brujaIndex: brujaIndex ?? this.brujaIndex,
      brujaAsignada: brujaAsignada ?? this.brujaAsignada,
      pocionVidaUsada: pocionVidaUsada ?? this.pocionVidaUsada,
      pocionVidaObjetivo: pocionVidaObjetivo ?? this.pocionVidaObjetivo,
      pocionMuerteUsada: pocionMuerteUsada ?? this.pocionMuerteUsada,
      pocionMuerteObjetivo: pocionMuerteObjetivo ?? this.pocionMuerteObjetivo,
    );
  }

  bool isBruja(int index) => brujaIndex != null && index == brujaIndex;
}

// ===== Acciones de la Bruja =====

BrujaFlow assignBruja({
  required int index,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required Rol Function(String nombre) resolverRol,
  required BuildContext context,
}) {
  final brujaRol = resolverRol('Bruja');
  rolesAsignados[index] = brujaRol;

  mostrarNotificacionArriba(context, '${jugadores[index]} es la Bruja');

  return BrujaFlow(brujaIndex: index, brujaAsignada: true);
}

// ===== Helpers visuales para la mesa =====

/// Renderiza la carta completa si el índice es la Bruja.
/// Si no, el avatar normal con badges de pociones (vida/muerte).
Widget buildBrujaAvatar({
  required BrujaFlow flow,
  required int index,
  required String nombre,
  double avatarRadius = 28.0,
  String cardAsset = 'assets/roles/bruja.png',
  String vidaAsset = 'assets/roles/pocion_vida.png',
  String muerteAsset = 'assets/roles/pocion_muerte.png',
}) {
  final isBruj = flow.isBruja(index);

  return Stack(
    clipBehavior: Clip.none,
    children: [
      if (isBruj)
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
      if (isBruj && flow.pocionVidaUsada)
        Positioned(
          right: -2,
          top: -2,
          child: Image.asset(
            vidaAsset,
            width: 16,
            height: 16,
            color: Colors.grey, // indica que ya se usó
          ),
        ),
      if (isBruj && flow.pocionMuerteUsada)
        Positioned(
          right: -2,
          bottom: -2,
          child: Image.asset(
            muerteAsset,
            width: 16,
            height: 16,
            color: Colors.grey, // indica que ya se usó
          ),
        ),
    ],
  );
}
