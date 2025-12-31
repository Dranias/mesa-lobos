import 'package:flutter/material.dart';
import '../data/reglas_cada_noche.dart';
import '../data/roles.dart';
import '../roles/vidente.dart';
import '../roles/lobos_comunes.dart';
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
    required List<Rol?> catalogo,
    required BuildContext context,
    required void Function(VidenteFlow) updateVidente,
    required void Function(LobosComunesFlow) updateLobos,
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
                context, 'La Vidente observa a: ${jugadores[videnteFlow.objetivoIndex!]}');
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
                context, 'Los lobos atacarán a: ${jugadores[lobosFlow.victimaIndex!]}');
          }
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
