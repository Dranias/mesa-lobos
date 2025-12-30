import 'package:flutter/material.dart';
import '../data/reglas_dia.dart';
import '../data/roles.dart';

class DiaAldea {
  static List<Regla> generarSecuencia(List<Rol?> rolesSeleccionados) {
    final activos = rolesSeleccionados
        .where((r) => r != null)
        .map((r) => r!.nombre)
        .toList();

    if (!activos.contains('Alguacil')) activos.add('Alguacil');

    return reglasDia
        .where((r) => activos.contains(r.rol))
        .toList()
      ..sort((a, b) => a.orden.compareTo(b.orden));
  }

  /// Anuncia la víctima de la noche y abre el sistema de votación
  static void ejecutarDia({
    required BuildContext context,
    required List<String> jugadores,
    required Map<int, Rol> rolesAsignados,
    required Set<int> jugadoresMuertos,
    required int? victimaDeLobos,
    required void Function(int) onLinchamiento,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Día en la aldea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (victimaDeLobos != null)
                Text(
                  'Los hombres lobo han decidido matar a ${jugadores[victimaDeLobos]}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 12),
              const Text('La gente de la aldea se junta y comienzan a debatir.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _abrirVotacion(
                    context: context,
                    jugadores: jugadores,
                    rolesAsignados: rolesAsignados,
                    jugadoresMuertos: jugadoresMuertos,
                    onLinchamiento: onLinchamiento,
                  );
                },
                child: const Text('Comenzar votación'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Sistema de votación interactivo
  static void _abrirVotacion({
    required BuildContext context,
    required List<String> jugadores,
    required Map<int, Rol> rolesAsignados,
    required Set<int> jugadoresMuertos,
    required void Function(int) onLinchamiento,
  }) {
    final votos = <int, int>{}; // jugador -> index de su voto
    final conteo = <int, int>{}; // index -> número de votos recibidos

    void registrarVoto(int votante, int objetivo) {
      final votoAnterior = votos[votante];
      if (votoAnterior != null) {
        conteo[votoAnterior] = (conteo[votoAnterior] ?? 0) - 1;
      }
      votos[votante] = objetivo;
      conteo[objetivo] = (conteo[objetivo] ?? 0) + 1;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('Votación de la aldea'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: jugadores.length,
                  itemBuilder: (context, index) {
                    final nombre = jugadores[index];
                    final muerto = jugadoresMuertos.contains(index);

                    return ListTile(
                      leading: muerto
                          ? const Icon(Icons.close, color: Colors.red)
                          : const Icon(Icons.person),
                      title: Text(nombre),
                      subtitle: Text(
                        muerto
                            ? 'Muerto'
                            : 'Votos recibidos: ${conteo[index] ?? 0}',
                      ),
                      enabled: !muerto,
                      onTap: () {
                        // Al dar click en un jugador, vota contra otro
                        showDialog(
                          context: context,
                          builder: (ctx2) {
                            return SimpleDialog(
                              title: Text('¿Contra quién vota $nombre?'),
                              children: [
                                for (int j = 0; j < jugadores.length; j++)
                                  if (j != index &&
                                      !jugadoresMuertos.contains(j))
                                    SimpleDialogOption(
                                      onPressed: () {
                                        setState(() {
                                          registrarVoto(index, j);
                                        });
                                        Navigator.of(ctx2).pop();
                                      },
                                      child: Text(jugadores[j]),
                                    ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // Determinar el más votado
                    int? victima;
                    int maxVotos = -1;
                    conteo.forEach((jugador, votosRecibidos) {
                      if (votosRecibidos > maxVotos) {
                        maxVotos = votosRecibidos;
                        victima = jugador;
                      }
                    });
                    Navigator.of(ctx).pop();
                    if (victima != null) {
                      onLinchamiento(victima!);
                    }
                  },
                  child: const Text('Finalizar votación'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Método requerido por mesa_screen.dart
  static void ejecutarPaso({
    required Regla reglaActual,
    required int index,
    required List<String> jugadores,
    required Map<int, Rol> rolesAsignados,
    required Set<int> jugadoresMuertos,
    required Map<String, List<String>> relaciones,
    required BuildContext context,
  }) {
    switch (reglaActual.rol) {
      case 'Alguacil':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El Alguacil incita a votar.')),
        );
        break;
      default:
        // Por ahora no hace nada especial
        break;
    }
  }
}
