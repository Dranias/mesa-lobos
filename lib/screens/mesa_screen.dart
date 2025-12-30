// screens/mesa_screen.dart
import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../data/reglas.dart';
import '../widgets/mesa_jugadores.dart';
import '../widgets/narrador_card.dart';
import '../widgets/roles_drawer.dart';
import '../managers/roles_manager.dart';

import '../roles/cupido.dart';
import '../roles/nino_salvaje.dart';

class MesaScreen extends StatefulWidget {
  final List<String> jugadores;
  final List<Rol?> rolesSeleccionados;

  const MesaScreen({
    super.key,
    required this.jugadores,
    required this.rolesSeleccionados,
  });

  @override
  State<MesaScreen> createState() => _MesaScreenState();
}

class _MesaScreenState extends State<MesaScreen> {
  int nocheActual = 1;
  int pasoActual = 0;
  late List<Regla> secuencia;

  final Map<int, Rol> rolesAsignados = {};
  final Map<String, List<String>> relaciones = {};

  //Flujos especiales
  CupidoFlow cupidoFlow = CupidoFlow.reset();
  NinoSalvajeFlow ninoFlow = NinoSalvajeFlow.reset();

  @override
  void initState() {
    super.initState();

    // Inicializa todos como Aldeano por defecto
    final aldeano = resolveRolByName('Aldeano', widget.rolesSeleccionados);
    for (int i = 0; i < widget.jugadores.length; i++) {
      rolesAsignados[i] = aldeano;
    }

    _generarSecuencia();
  }

  void _generarSecuencia() {
    final activos = widget.rolesSeleccionados
        .where((r) => r != null)
        .map((r) => r!.nombre)
        .toList();

    if (!activos.contains('Alguacil')) activos.add('Alguacil');

    secuencia = reglas.where((r) {
      if (!activos.contains(r.rol)) return false;
      if (r.momento == 'primera_noche' && nocheActual == 1) return true;
      if (r.momento == 'cada_noche') return true;
      return false;
    }).toList()..sort((a, b) => a.orden.compareTo(b.orden));

    pasoActual = 0;
  }

  void _siguientePaso() {
    setState(() {
      if (pasoActual < secuencia.length - 1) {
        pasoActual++;
      } else {
        nocheActual++;
        _generarSecuencia();
      }
    });
  }

  void _asignarRolGenerico(int index, String nombreRol) {
    final reglaActual = secuencia.isNotEmpty ? secuencia[pasoActual] : null;

    setState(() {
      if (nombreRol == 'Cupido' && !cupidoFlow.cupidoAsignado) {
        // Paso 1: despertar y asignar a Cupido
        cupidoFlow = assignCupido(
          index: index,
          jugadores: widget.jugadores,
          rolesAsignados: rolesAsignados,
          resolverRol: (nombre) =>
              resolveRolByName(nombre, widget.rolesSeleccionados),
          context: context,
        );
        return;
      }

      if (reglaActual?.rol == 'Cupido' &&
          cupidoFlow.cupidoAsignado &&
          !cupidoFlow.primerEnamoradoAsignado) {
        // Paso 2: seleccionar primer enamorado
        cupidoFlow = selectPrimerEnamorado(
          index: index,
          flow: cupidoFlow,
          jugadores: widget.jugadores,
          context: context,
        );
        return;
      }

      if (reglaActual?.rol == 'Cupido' &&
          cupidoFlow.primerEnamoradoAsignado &&
          !cupidoFlow.segundoEnamoradoAsignado) {
        // Paso 3: seleccionar segundo enamorado
        cupidoFlow = selectSegundoEnamorado(
          index: index,
          flow: cupidoFlow,
          jugadores: widget.jugadores,
          relaciones: relaciones,
          context: context,
        );
        return;
      }

      // NIÑO SALVAJE: dos pasos
      if (nombreRol == 'Niño Salvaje' && !ninoFlow.ninoAsignado) {
        ninoFlow = assignNinoSalvaje(
          index: index,
          jugadores: widget.jugadores,
          rolesAsignados: rolesAsignados,
          resolverRol: (nombre) =>
              resolveRolByName(nombre, widget.rolesSeleccionados),
          context: context,
        );
        return;
      }
      if (reglaActual?.rol == 'Niño Salvaje' &&
          ninoFlow.ninoAsignado &&
          !ninoFlow.modeloAsignado) {
        ninoFlow = selectModelo(
          index: index,
          flow: ninoFlow,
          jugadores: widget.jugadores,
          relaciones: relaciones,
          context: context,
        );
        return;
      }

      // Otros roles (si aplica)
      assignGenericRole(
        index: index,
        nombreRol: nombreRol,
        jugadores: widget.jugadores,
        rolesAsignados: rolesAsignados,
        catalogo: widget.rolesSeleccionados,
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final reglaActual = secuencia.isNotEmpty ? secuencia[pasoActual] : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Mesa de juego')),
      endDrawer: RolesDrawer(
        rolesAsignados: rolesAsignados,
        relaciones: relaciones,
        jugadores: widget.jugadores,
      ),
      body: Column(
        children: [
          Expanded(
            child: MesaJugadores(
              jugadores: widget.jugadores,
              rolesAsignados: rolesAsignados,
              rolActivo: reglaActual?.rol,
              onAsignarRolGenerico: _asignarRolGenerico,
              cupidoFlow: cupidoFlow,
              ninoFlow: ninoFlow,
            ),
          ),

          if (reglaActual != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: NarradorCard(
                  nocheActual: nocheActual,
                  pasoActual: pasoActual,
                  totalPasos: secuencia.length,
                  rolActivo: reglaActual.rol,
                  cupidoAsignado: cupidoFlow.cupidoAsignado,
                  primerEnamoradoAsignado: cupidoFlow.primerEnamoradoAsignado,
                  segundoEnamoradoAsignado: cupidoFlow.segundoEnamoradoAsignado,
                  ninoAsignado: ninoFlow.ninoAsignado, 
                  modeloAsignado: ninoFlow.modeloAsignado,
                  onNext: _siguientePaso,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
