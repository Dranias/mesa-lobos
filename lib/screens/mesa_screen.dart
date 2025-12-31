import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../widgets/mesa_jugadores.dart';
import '../widgets/narrador_card.dart';
import '../widgets/roles_drawer.dart';

// Flujos especiales
import '../roles/cupido.dart';
import '../roles/nino_salvaje.dart';
import '../roles/vidente.dart';
import '../roles/lobos_comunes.dart';

// Managers
import '../managers/roles_manager.dart';

// Reglas con alias
import '../data/reglas_primera_noche.dart' as primera;
import '../data/reglas_cada_noche.dart' as cada;
import '../data/reglas_dia.dart' as dia;
import '../data/reglas_al_morir.dart' as morir;

// Phases
import '../phases/primera_noche.dart';
import '../phases/noche_aldea.dart';
import '../phases/dia_aldea.dart';

class MesaScreen extends StatefulWidget {
  final List<String> jugadores;
  final List<Rol?> rolesSeleccionados;
  final int cantidadLobos;

  const MesaScreen({
    super.key,
    required this.jugadores,
    required this.rolesSeleccionados,
    required this.cantidadLobos,
  });

  @override
  State<MesaScreen> createState() => _MesaScreenState();
}

class _MesaScreenState extends State<MesaScreen> {
  int nocheActual = 1;
  int pasoActual = 0;

  // Usamos dynamic para que pueda contener reglas de cualquier módulo
  late List<dynamic> secuencia;

  final Map<int, Rol> rolesAsignados = {};
  final Map<String, List<String>> relaciones = {};
  final Set<int> jugadoresMuertos = {};

  bool esNoche = true;

  // Flujos especiales
  CupidoFlow cupidoFlow = CupidoFlow.reset();
  NinoSalvajeFlow ninoFlow = NinoSalvajeFlow.reset();
  VidenteFlow videnteFlow = VidenteFlow.reset();
  LobosComunesFlow lobosFlow = LobosComunesFlow.reset();

  int? alguacilIndex;

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
    if (!esNoche) {
      secuencia = dia.reglasDia;
      pasoActual = 0;
      return;
    }

    if (nocheActual == 1) {
      secuencia = PrimeraNoche.generarSecuencia(widget.rolesSeleccionados);
    } else {
      secuencia = NocheAldea.generarSecuencia(widget.rolesSeleccionados);
    }

    pasoActual = 0;
  }

  void _siguientePaso() {
    setState(() {
      if (pasoActual < secuencia.length - 1) {
        pasoActual++;
      } else {
        if (esNoche) {
          if (lobosFlow.victimaIndex != null) {
            _eliminarJugador(lobosFlow.victimaIndex!);
          }
          esNoche = false;
          secuencia = dia.reglasDia;
          pasoActual = 0;

          DiaAldea.ejecutarDia(
            context: context,
            jugadores: widget.jugadores,
            rolesAsignados: rolesAsignados,
            jugadoresMuertos: jugadoresMuertos,
            victimaDeLobos: lobosFlow.victimaIndex,
            onLinchamiento: (index) {
              _eliminarJugador(index);
              setState(() {
                esNoche = true;
                nocheActual++;
                _generarSecuencia();
              });
            },
          );
        } else {
          nocheActual++;
          esNoche = true;
          _generarSecuencia();
          pasoActual = 0;
        }
      }
    });
  }

  void _eliminarJugador(int indexVictima) {
    final nombreVictima = widget.jugadores[indexVictima];
    jugadoresMuertos.add(indexVictima);
    relaciones.removeWhere((rol, lista) => lista.contains(nombreVictima));
    lobosFlow = lobosFlow.copyWith(victimaIndex: null);
  }

  void _asignarRolGenerico(int index, String nombreRol) {
    final reglaActual = secuencia.isNotEmpty ? secuencia[pasoActual] : null;
    if (reglaActual == null) return;

    setState(() {
      if (nombreRol == 'Alguacil') {
        alguacilIndex = index;
      }

      // --- Primera noche ---
      if (esNoche && nocheActual == 1) {
        PrimeraNoche.ejecutarPaso(
          reglaActual: reglaActual,
          index: index,
          jugadores: widget.jugadores,
          rolesAsignados: rolesAsignados,
          relaciones: relaciones,
          cupidoFlow: cupidoFlow,
          ninoFlow: ninoFlow,
          videnteFlow: videnteFlow,
          lobosFlow: lobosFlow,
          catalogo: widget.rolesSeleccionados,
          context: context,
          updateCupido: (f) => cupidoFlow = f,
          updateNino: (f) => ninoFlow = f,
          updateVidente: (f) => videnteFlow = f,
          updateLobos: (f) => lobosFlow = f,
        );
      }
      // --- Otras noches ---
      else if (esNoche) {
        NocheAldea.ejecutarPaso(
          reglaActual: reglaActual,
          index: index,
          jugadores: widget.jugadores,
          rolesAsignados: rolesAsignados,
          relaciones: relaciones,
          videnteFlow: videnteFlow,
          lobosFlow: lobosFlow,
          catalogo: widget.rolesSeleccionados,
          context: context,
          updateVidente: (f) => videnteFlow = f,
          updateLobos: (f) => lobosFlow = f,
        );
      }
      // --- Día ---
      else {
        DiaAldea.ejecutarPaso(
          reglaActual: reglaActual,
          index: index,
          jugadores: widget.jugadores,
          rolesAsignados: rolesAsignados,
          jugadoresMuertos: jugadoresMuertos,
          relaciones: relaciones,
          context: context,
        );
      }
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
        rolesIniciales: widget.rolesSeleccionados,
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
              videnteFlow: videnteFlow,
              lobosFlow: lobosFlow,
              alguacilIndex: alguacilIndex,
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
                  videnteAsignada: videnteFlow.videnteAsignada,
                  objetivoAsignado: videnteFlow.objetivoAsignado,
                  cantidadLobos: widget.cantidadLobos,
                  lobosSeleccionados: lobosFlow.lobosIndices.length,
                  victimaAsignada: lobosFlow.victimaIndex != null,
                  onNext: _siguientePaso,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
