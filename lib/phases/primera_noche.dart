import 'package:flutter/material.dart';
import '../utils/notificaciones.dart';

import '../data/reglas_primera_noche.dart';
import '../data/roles.dart';
import '../managers/roles_manager.dart';
import '../roles/cupido.dart';
import '../roles/nino_salvaje.dart';
import '../roles/vidente.dart';
import '../roles/lobos_comunes.dart';
import '../roles/bruja.dart'; // 👈 flujo y helpers de la Bruja

class PrimeraNoche {
  static List<Regla> generarSecuencia(List<Rol?> rolesSeleccionados) {
    final activos = rolesSeleccionados
        .where((r) => r != null)
        .map((r) => r!.nombre)
        .toList();

    final reglas = reglasPrimeraNoche
        .where((r) => activos.contains(r.rol) || r.rol == 'Alguacil')
        .toList()
      ..sort((a, b) => a.orden.compareTo(b.orden));

    return reglas;
  }

  static void ejecutarPaso({
    required Regla reglaActual,
    required int index,
    required List<String> jugadores,
    required Map<int, Rol> rolesAsignados,
    required Map<String, List<String>> relaciones,
    required CupidoFlow cupidoFlow,
    required NinoSalvajeFlow ninoFlow,
    required VidenteFlow videnteFlow,
    required LobosComunesFlow lobosFlow,
    required BrujaFlow brujaFlow,
    required List<Rol?> catalogo,
    required BuildContext context,
    required void Function(CupidoFlow) updateCupido,
    required void Function(NinoSalvajeFlow) updateNino,
    required void Function(VidenteFlow) updateVidente,
    required void Function(LobosComunesFlow) updateLobos,
    required void Function(BrujaFlow) updateBruja,
  }) {
    final activos = catalogo
        .where((r) => r != null)
        .map((r) => r!.nombre)
        .toList();

    if (!activos.contains(reglaActual.rol)) return;

    switch (reglaActual.rol) {
      case 'Cupido':
        if (!cupidoFlow.cupidoAsignado) {
          updateCupido(
            assignCupido(
              index: index,
              jugadores: jugadores,
              rolesAsignados: rolesAsignados,
              resolverRol: (nombre) => resolveRolByName(nombre, catalogo),
              context: context,
            ),
          );
        } else if (!cupidoFlow.primerEnamoradoAsignado) {
          updateCupido(
            selectPrimerEnamorado(
              index: index,
              flow: cupidoFlow,
              jugadores: jugadores,
              context: context,
            ),
          );
        } else if (!cupidoFlow.segundoEnamoradoAsignado) {
          updateCupido(
            selectSegundoEnamorado(
              index: index,
              flow: cupidoFlow,
              jugadores: jugadores,
              relaciones: relaciones,
              context: context,
            ),
          );
          if (cupidoFlow.primerEnamoradoIndex != null &&
              cupidoFlow.segundoEnamoradoIndex != null) {
            relaciones['enamorados'] = [
              jugadores[cupidoFlow.primerEnamoradoIndex!],
              jugadores[cupidoFlow.segundoEnamoradoIndex!],
            ];
          }
        }
        break;

      case 'Niño Salvaje':
        if (!ninoFlow.ninoAsignado) {
          updateNino(
            assignNinoSalvaje(
              index: index,
              jugadores: jugadores,
              rolesAsignados: rolesAsignados,
              resolverRol: (nombre) => resolveRolByName(nombre, catalogo),
              context: context,
            ),
          );
        } else if (!ninoFlow.modeloAsignado) {
          updateNino(
            selectModelo(
              index: index,
              flow: ninoFlow,
              jugadores: jugadores,
              relaciones: relaciones,
              context: context,
            ),
          );
        }
        break;

      case 'Vidente':
        if (!videnteFlow.videnteAsignada) {
          updateVidente(
            assignVidente(
              index: index,
              jugadores: jugadores,
              rolesAsignados: rolesAsignados,
              resolverRol: (nombre) => resolveRolByName(nombre, catalogo),
              context: context,
            ),
          );
        } else if (!videnteFlow.objetivoAsignado) {
          updateVidente(
            observarJugador(
              index: index,
              flow: videnteFlow,
              jugadores: jugadores,
              rolesAsignados: rolesAsignados,
              relaciones: relaciones,
              context: context,
            ),
          );
        }
        break;

      case 'Hombres Lobo Comunes':
        if (lobosFlow.lobosIndices.length <
            catalogo.where((r) => r?.nombre == 'Hombres Lobo Comunes').length) {
          updateLobos(
            assignLoboComun(
              index: index,
              jugadores: jugadores,
              rolesAsignados: rolesAsignados,
              resolverRol: (nombre) => resolveRolByName(nombre, catalogo),
              flow: lobosFlow,
              context: context,
            ),
          );
        } else if (lobosFlow.asignados && lobosFlow.victimaIndex == null) {
          updateLobos(
            elegirVictimaComun(
              index: index,
              jugadores: jugadores,
              flow: lobosFlow,
              context: context,
            ),
          );
        }
        break;

      case 'Bruja':
        if (!brujaFlow.brujaAsignada) {
          // 👇 asigna la carta PNG de la Bruja
          updateBruja(
            assignBruja(
              index: index,
              jugadores: jugadores,
              rolesAsignados: rolesAsignados,
              resolverRol: (nombre) => resolveRolByName(nombre, catalogo),
              context: context,
            ),
          );
        }

        // Preguntar si desea usar poderes
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('La Bruja despierta'),
              content: const Text('¿Desea usar sus poderes esta noche?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('No usar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showDialog(
                      context: context,
                      builder: (ctx2) {
                        return AlertDialog(
                          title: const Text('¿Qué poción desea usar la Bruja?'),
                          actions: [
                            TextButton(
                              onPressed: brujaFlow.pocionVidaUsada ||
                                      lobosFlow.victimaIndex == null
                                  ? null
                                  : () {
                                      updateBruja(
                                        brujaFlow.copyWith(
                                          pocionVidaUsada: true,
                                          pocionVidaObjetivo: lobosFlow.victimaIndex,
                                        ),
                                      );
                                      mostrarNotificacionArriba(
                                        context,
                                        'La Bruja salva a ${jugadores[lobosFlow.victimaIndex!]}',
                                      );
                                      Navigator.pop(ctx2);
                                    },
                              child: const Text('Poción de vida'),
                            ),
                            TextButton(
                              onPressed: brujaFlow.pocionMuerteUsada
                                  ? null
                                  : () {
                                      updateBruja(
                                        brujaFlow.copyWith(
                                          pocionMuerteUsada: true,
                                          pocionMuerteObjetivo: index,
                                        ),
                                      );
                                      mostrarNotificacionArriba(
                                        context,
                                        'La Bruja envenena a ${jugadores[index]}',
                                      );
                                      relaciones.putIfAbsent('muertes', () => []);
                                      relaciones['muertes']!.add(jugadores[index]);
                                      Navigator.pop(ctx2);
                                    },
                              child: const Text('Poción de muerte'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Usar poderes'),
                ),
              ],
            );
          },
        );
        break;

      default:
        assignGenericRole(
          index: index,
          nombreRol: reglaActual.rol,
          jugadores: jugadores,
          rolesAsignados: rolesAsignados,
          catalogo: catalogo,
          context: context,
        );
    }
  }
}
