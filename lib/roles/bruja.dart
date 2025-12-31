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
