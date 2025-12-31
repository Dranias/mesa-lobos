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

const List<Regla> reglasDia = [
  
];
