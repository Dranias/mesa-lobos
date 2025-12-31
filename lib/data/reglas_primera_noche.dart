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

const List<Regla> reglasPrimeraNoche = [
  // --- Primera noche: despertar/definir roles (configuración del narrador) ---
  Regla(
    rol: 'Alguacil',
    momento: 'primera_noche',
    orden: 0,
    frecuencia: 'una_vez',
    condicion: 'Se designa qué jugador es el alguacil',
  ),
  Regla(
    rol: 'Cupido',
    momento: 'primera_noche',
    orden: 1,
    frecuencia: 'una_vez',
    condicion: 'Designa a dos enamorados',
  ),
  Regla(
    rol: 'Vidente',
    momento: 'primera_noche',
    orden: 2,
    frecuencia: 'una_vez',
    condicion: 'Puede ver la carta de un jugador',
  ),
  Regla(
    rol: 'Niño Salvaje',
    momento: 'primera_noche',
    orden: 3,
    frecuencia: 'una_vez',
    condicion: 'Elige a un jugador modelo',
  ),
  Regla(
    rol: 'Hombres Lobo Comunes',
    momento: 'primera_noche',
    orden: 4,
    frecuencia: 'una_vez',
    condicion: 'El narrador asigna a los jugadores que serán lobos comunes y eligen víctima',
  ),
  Regla(
    rol: 'Bruja',
    momento: 'primera_noche',
    orden: 5,
    frecuencia: 'una_vez',
    condicion: 'Se revela y decide si usa sus poderes (vida o muerte)',
  ),
];
