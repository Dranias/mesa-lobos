  import 'package:flutter/material.dart';
  import '../data/reglas_dia.dart';
  import '../data/roles.dart';
  import '../utils/notificaciones.dart';

  class DiaAldea {
    static List<Regla> generarSecuencia(List<Rol?> rolesSeleccionados) {
      final activos = rolesSeleccionados
          .where((r) => r != null)
          .map((r) => r!.nombre)
          .toList();

      return reglasDia.where((r) => activos.contains(r.rol)).toList()
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
      required int? alguacilIndex,
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
                const Text(
                  'La gente de la aldea se junta y comienzan a debatir.',
                ),
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
                      alguacilIndex: alguacilIndex,
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
      required int? alguacilIndex,
    }) {
      final votos = <int, int>{}; // jugador -> index de su voto
      final conteo = <int, int>{}; // index -> número de votos recibidos

      void registrarVoto(int votante, int objetivo) {
        final votoAnterior = votos[votante];
        if (votoAnterior != null) {
          final pesoAnterior = (votante == alguacilIndex) ? 2 : 1;
          conteo[votoAnterior] = (conteo[votoAnterior] ?? 0) - pesoAnterior;
        }

        votos[votante] = objetivo;

        // 👇 sumar correctamente según el peso del votante
        final peso = (votante == alguacilIndex) ? 2 : 1;
        conteo[objetivo] = (conteo[objetivo] ?? 0) + peso;
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
                            ? Image.asset(
                                'assets/roles/muerto.png',
                                width: 32,
                                height: 32,
                              )
                            : (alguacilIndex == index
                                  ? Image.asset(
                                      'assets/roles/alguacil.png',
                                      width: 48,
                                      height: 48,
                                    )
                                  : const Icon(Icons.person, size: 32)),

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
                                          mostrarNotificacionArriba(
                                            context,
                                            '$nombre votó contra ${jugadores[j]}',
                                          );
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
                        mostrarNotificacionArriba(
                          context,
                          '${jugadores[victima!]} fue linchado por la aldea',
                        );
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
      required void Function(int) updateAlguacil,
    }) {
      switch (reglaActual.rol) {
        case 'Alguacil':
          updateAlguacil(index);
          mostrarNotificacionArriba(
            context,
            '${jugadores[index]} es el nuevo Alguacil',
          );
          break;
        default:
          // Por ahora no hace nada especial
          break;
      }
    }
  }
