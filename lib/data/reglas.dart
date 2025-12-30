// data/reglas.dart
import 'roles.dart';

class Regla {
  final String rol;
  final String momento;      // "primera_noche", "cada_noche", "al_morir", "al_votar", "al_dia"
  final int orden;           // orden relativo dentro de la noche
  final String frecuencia;   // "una_vez", "repetido", "condicional"
  final String? condicion;

  const Regla({
    required this.rol,
    required this.momento,
    required this.orden,
    required this.frecuencia,
    this.condicion,
  });
}

const List<Regla> reglas = [
  // --- Primera noche ---
  Regla(rol: 'Cupido', momento: 'primera_noche', orden: 1, frecuencia: 'una_vez',
    condicion: 'Designa a dos enamorados'),
  Regla(rol: 'Dos Hermanas', momento: 'primera_noche', orden: 2, frecuencia: 'una_vez',
    condicion: 'Se reconocen entre sí'),
  Regla(rol: 'Tres Hermanos', momento: 'primera_noche', orden: 3, frecuencia: 'una_vez',
    condicion: 'Se reconocen entre sí'),
  Regla(rol: 'Niño Salvaje', momento: 'primera_noche', orden: 4, frecuencia: 'una_vez',
    condicion: 'Elige a un jugador modelo'),
  Regla(rol: 'Perro Lobo', momento: 'primera_noche', orden: 5, frecuencia: 'una_vez',
    condicion: 'Decide si será Aldeano o Lobo'),
  Regla(rol: 'Juez Tartamudo', momento: 'primera_noche', orden: 6, frecuencia: 'una_vez',
    condicion: 'Indica al narrador su gesto especial'),
  Regla(rol: 'Ladrón', momento: 'primera_noche', orden: 7, frecuencia: 'una_vez',
    condicion: 'Puede mirar dos cartas sobrantes y quedarse con una'),

  // --- Cada noche ---
  Regla(rol: 'Vidente', momento: 'cada_noche', orden: 10, frecuencia: 'repetido',
    condicion: 'Puede ver la carta de un jugador'),
  Regla(rol: 'Protector', momento: 'cada_noche', orden: 11, frecuencia: 'repetido',
    condicion: 'Protege a un jugador antes de los lobos'),
  Regla(rol: 'Hombres Lobo', momento: 'cada_noche', orden: 12, frecuencia: 'repetido',
    condicion: 'Devoran a un aldeano'),
  Regla(rol: 'Lobo Feroz', momento: 'cada_noche', orden: 13, frecuencia: 'condicional',
    condicion: 'Despierta segunda vez si ningún lobo ha muerto'),
  Regla(rol: 'Infecto Padre de todos los Lobos', momento: 'cada_noche', orden: 14, frecuencia: 'condicional',
    condicion: 'Puede infectar una vez por partida'),
  Regla(rol: 'Hombre Lobo Albino', momento: 'cada_noche', orden: 15, frecuencia: 'condicional',
    condicion: 'Cada dos noches puede eliminar a un lobo'),
  Regla(rol: 'Bruja', momento: 'cada_noche', orden: 16, frecuencia: 'repetido',
    condicion: 'Tiene una poción de vida y una de muerte'),
  Regla(rol: 'Zorro', momento: 'cada_noche', orden: 17, frecuencia: 'repetido',
    condicion: 'Puede revisar 3 vecinos para detectar lobos'),
  Regla(rol: 'Flautista', momento: 'cada_noche', orden: 18, frecuencia: 'repetido',
    condicion: 'Encanta a dos jugadores cada noche'),
  Regla(rol: 'Niña Pequeña', momento: 'cada_noche', orden: 19, frecuencia: 'condicional',
    condicion: 'Puede entreabrir los ojos mientras los lobos despiertan'),
  Regla(rol: 'Gitana', momento: 'cada_noche', orden: 20, frecuencia: 'repetido',
    condicion: 'Puede usar cartas de Espiritismo'),

  // --- Al morir ---
  Regla(rol: 'Cazador', momento: 'al_morir', orden: 30, frecuencia: 'una_vez',
    condicion: 'Dispara a otro jugador'),
  Regla(rol: 'Anciano', momento: 'al_morir', orden: 31, frecuencia: 'condicional',
    condicion: 'Si muere por linchamiento, aldeanos pierden poderes'),
  Regla(rol: 'Caballero de la Espada Oxidada', momento: 'al_morir', orden: 32, frecuencia: 'una_vez',
    condicion: 'Al morir, un lobo cercano muere la noche siguiente'),
  Regla(rol: 'Abnegada Sirvienta', momento: 'al_morir', orden: 33, frecuencia: 'condicional',
    condicion: 'Puede cambiar su carta por la del jugador eliminado'),

  // --- Al votar / durante el día ---
  Regla(rol: 'Alguacil', momento: 'al_votar', orden: 99, frecuencia: 'repetido',
    condicion: 'Sus votos cuentan doble; siempre existe como rol adicional'),
  Regla(rol: 'Cabeza de Turco', momento: 'al_votar', orden: 100, frecuencia: 'condicional',
    condicion: 'Si hay empate, él es linchado'),
  Regla(rol: 'Tonto de la Aldea', momento: 'al_votar', orden: 101, frecuencia: 'condicional',
    condicion: 'Si es votado, muestra su carta y no puede ser linchado'),
  Regla(rol: 'Domador de Osos', momento: 'al_dia', orden: 102, frecuencia: 'repetido',
    condicion: 'Cada mañana el narrador gruñe si tiene lobos adyacentes'),
  Regla(rol: 'Ángel', momento: 'primera_noche', orden: 103, frecuencia: 'una_vez',
    condicion: 'Si es linchado o devorado primero, gana'),

  // --- Otros especiales ---
  Regla(rol: 'Comediante', momento: 'cada_noche', orden: 110, frecuencia: 'repetido',
    condicion: 'Puede usar poderes de cartas sobrantes'),
  Regla(rol: 'Abominable Sectario', momento: 'inicio_partida', orden: 111, frecuencia: 'una_vez',
    condicion: 'Narrador divide la aldea en dos grupos'),
];
