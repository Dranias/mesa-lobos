import 'package:flutter/material.dart';
import '../data/reglas_cada_noche.dart';
import '../data/roles.dart';
import '../roles/vidente.dart';
import '../roles/lobos_comunes.dart';
import '../roles/bruja.dart';
import '../managers/roles_manager.dart';
import '../utils/notificaciones.dart';

class NocheAldea {
  static List<Regla> generarSecuencia(List<Rol?> rolesSeleccionados) {
    final activos = rolesSeleccionados
        .where((r) => r != null)
        .map((r) => r!.nombre)
        .toList();

    return reglasCadaNoche
        .where((r) => activos.contains(r.rol))
        .toList()
      ..sort((a, b) => a.orden.compareTo(b.orden));
  }

  static void ejecutarPaso({
    required Regla reglaActual,
    required int index,
    required List<String> jugadores,
    required Map<int, Rol> rolesAsignados,
    required Map<String, List<String>> relaciones,
    required VidenteFlow videnteFlow,
    required LobosComunesFlow lobosFlow,
    required BrujaFlow brujaFlow,
    required List<Rol?> catalogo,
    required BuildContext context,
    required void Function(VidenteFlow) updateVidente,
    required void Function(LobosComunesFlow) updateLobos,
    required void Function(BrujaFlow) updateBruja,
    required Set<int> jugadoresMuertos,
    required Map<int, Rol> rolesIniciales,
  }) {
    if (!catalogo.any((r) => r?.nombre == reglaActual.rol)) return;

    switch (reglaActual.rol) {
      case 'Vidente':
        if (!videnteFlow.videnteAsignada) {
          updateVidente(assignVidente(
            index: index,
            jugadores: jugadores,
            rolesAsignados: rolesAsignados,
            resolverRol: (nombre) => resolveRolByName(nombre, catalogo),
            context: context,
          ));
          mostrarNotificacionArriba(context, '${jugadores[index]} es la Vidente');
        } else if (!videnteFlow.objetivoAsignado) {
          updateVidente(observarJugador(
            index: index,
            flow: videnteFlow,
            jugadores: jugadores,
            rolesAsignados: rolesAsignados,
            relaciones: relaciones,
            context: context,
          ));
          if (videnteFlow.objetivoIndex != null) {
            mostrarNotificacionArriba(
              context,
              'La Vidente observa a: ${jugadores[videnteFlow.objetivoIndex!]}',
            );
          }
        }
        break;

      case 'Hombres Lobo Comunes':
        if (lobosFlow.asignados && lobosFlow.victimaIndex == null) {
          updateLobos(elegirVictimaComun(
            index: index,
            jugadores: jugadores,
            flow: lobosFlow,
            context: context,
          ));
          if (lobosFlow.victimaIndex != null) {
            mostrarNotificacionArriba(
              context,
              'Los lobos atacarán a: ${jugadores[lobosFlow.victimaIndex!]}',
            );
          }
        }
        break;

      case 'Bruja':
        if (!brujaFlow.brujaAsignada) {
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

        if (!brujaFlow.pocionVidaUsada || !brujaFlow.pocionMuerteUsada) {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Acciones de la Bruja'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      icon: Image.asset('assets/roles/pocion_vida.png', width: 24, height: 24),
                      label: const Text('Usar poción de vida'),
                      onPressed: brujaFlow.pocionVidaUsada || jugadoresMuertos.isEmpty
                          ? null
                          : () {
                              Navigator.pop(ctx);
                              // Mostrar lista de jugadores muertos para elegir a quién revivir
                              showDialog(
                                context: context,
                                builder: (ctx2) {
                                  return AlertDialog(
                                    title: const Text('¿A quién desea revivir la Bruja?'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: jugadoresMuertos.map((muertoIndex) {
                                        return ListTile(
                                          title: Text(jugadores[muertoIndex]),
                                          onTap: () {
                                            // Quitar flag de muerto
                                            jugadoresMuertos.remove(muertoIndex);
                                            // Restaurar rol original
                                            rolesAsignados[muertoIndex] = rolesIniciales[muertoIndex]!;
                                            // Actualizar flujo
                                            updateBruja(
                                              brujaFlow.copyWith(
                                                pocionVidaUsada: true,
                                                pocionVidaObjetivo: muertoIndex,
                                              ),
                                            );
                                            // Registrar en relaciones para el Drawer
                                            relaciones.putIfAbsent('revividos', () => []);
                                            relaciones['revividos']!.add(jugadores[muertoIndex]);
                                            mostrarNotificacionArriba(
                                              context,
                                              'La Bruja revive a ${jugadores[muertoIndex]}',
                                            );
                                            Navigator.pop(ctx2);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              );
                            },
                    ),
                    ElevatedButton.icon(
                      icon: Image.asset('assets/roles/pocion_muerte.png', width: 24, height: 24),
                      label: const Text('Usar poción de muerte'),
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
                              Navigator.pop(ctx);
                            },
                    ),
                  ],
                ),
              );
            },
          );
        }
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
        mostrarNotificacionArriba(context, '${jugadores[index]} es ${reglaActual.rol}');
    }
  }
}
