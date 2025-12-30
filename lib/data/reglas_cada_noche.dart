class Regla {
  final String rol;
  final String momento;
  final int orden;
  final String frecuencia;
  final String? condicion;

  const Regla({
    required this.rol,
    required this.momento,
    required this.orden,
    required this.frecuencia,
    this.condicion,
  });
}

const List<Regla> reglasCadaNoche = [
  Regla(
    rol: 'Vidente',
    momento: 'cada_noche',
    orden: 1, // prioridad antes que lobos
    frecuencia: 'repetido',
    condicion: 'Puede ver la carta de un jugador',
  ),
  Regla(
    rol: 'Hombres Lobo Comunes',
    momento: 'cada_noche',
    orden: 2, // después de la Vidente
    frecuencia: 'repetido',
    condicion: 'Los lobos comunes devoran a un aldeano',
  ),
];
