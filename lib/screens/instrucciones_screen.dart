import 'package:flutter/material.dart';
import '../data/roles.dart'; // Importa la lista de roles

class InstruccionesScreen extends StatelessWidget {
  const InstruccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrucciones y Roles'),
      ),
      body: ListView(
        children: [
          // Sección inicial con reglas y desarrollo del juego
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Reglas generales',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Un narrador dirigirá la partida. Irá alternando los días y las noches, '
                    'llamará a los personajes y coordinará las acciones.\n\n'
                    'Durante la noche los jugadores cierran los ojos y el narrador despierta a los personajes '
                    'para que realicen sus acciones. Al terminar, llega el día.\n\n'
                    'Durante el día todos los jugadores abren los ojos y se revelan las víctimas o efectos ocurridos. '
                    'Los supervivientes deben debatir y votar para eliminar a un sospechoso. El más votado será linchado.\n\n'
                    'El objetivo de los Aldeanos es eliminar a todos los Hombres Lobo. '
                    'El objetivo de los Hombres Lobo es devorar a todos los Aldeanos. '
                    'Algunos personajes tienen objetivos individuales (ver Personajes).',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Desarrollo del juego',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'El narrador reparte las cartas boca abajo. Cada jugador mira su personaje en secreto.\n\n'
                    'El narrador duerme a la aldea diciendo: "Se hace de noche. La aldea duerme. Los jugadores cierran los ojos". '
                    'Luego llama por orden a los personajes que actúan de noche (lobos, bruja, etc.). Al terminar, llega el día.\n\n'
                    'El narrador despierta a la aldea diciendo: "Amanece en la aldea. Todos despiertan y abren los ojos. Todos excepto...". '
                    'Se anuncian las víctimas y comienza el debate.\n\n'
                    'Después del debate se vota. Cada jugador señala al sospechoso. El más votado muere linchado, revela su carta y queda fuera de la partida.\n\n'
                    'La aldea vuelve a dormir y el ciclo continúa hasta que gane un jugador o grupo.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Reparto recomendado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• De 6 a 11 jugadores: 2 lobos\n'
                    '• De 12 a 16 jugadores: 3 lobos\n'
                    '• De 16 o más jugadores: 4 lobos\n\n'
                    'Nota: "Aldeanos" se refiere a cualquier personaje que no sea Hombre Lobo. '
                    'Se pueden introducir personajes adicionales según se desee.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Tabla de roles
          ...roles.map((rol) {
            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna izquierda: nombre + imagen
                    Column(
                      children: [
                        Text(
                          rol.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Image.asset(
                          rol.imagen,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Columna derecha: descripción + objetivo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rol.descripcion,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Objetivo: ${rol.objetivo}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
