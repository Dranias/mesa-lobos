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

import '../utils/notificaciones.dart';

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

  Future<void> _mostrarCambioDeFase(String titulo) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(titulo),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _siguientePaso() async {
    if (pasoActual < secuencia.length - 1) {
      setState(() => pasoActual++);
    } else {
      if (esNoche) {
        // Termina la noche
        if (lobosFlow.victimaIndex != null) {
          await _eliminarJugador(lobosFlow.victimaIndex!, causa: 'lobos');
        }

        setState(() {
          esNoche = false;
          pasoActual = 0;
        });

        // 👇 Mostrar inicio del día
        await _mostrarCambioDeFase('Inicia Día $nocheActual');

        // Si el Alguacil murió, lo primero del día es reasignarlo
        if (alguacilIndex == null) {
          mostrarNotificacionArriba(
            context,
            'El Alguacil ha muerto. El narrador debe elegir un nuevo Alguacil antes de la votación.',
          );

          secuencia = [
            ...dia.reglasDia.where((r) => r.rol == 'Alguacil'),
            ...dia.reglasDia.where((r) => r.rol != 'Alguacil'),
          ];
          return;
        }

        // Generar secuencia del día
        secuencia = dia.reglasDia;
      } else {
        // Termina el día → aquí sí abrimos la votación
        await _mostrarCambioDeFase('Termina Día $nocheActual');

        DiaAldea.ejecutarDia(
          context: context,
          jugadores: widget.jugadores,
          rolesAsignados: rolesAsignados,
          jugadoresMuertos: jugadoresMuertos,
          victimaDeLobos: lobosFlow.victimaIndex,
          alguacilIndex: alguacilIndex,
          onLinchamiento: (index) async {
            await _eliminarJugador(index, causa: 'linchamiento');

            // Después del linchamiento, avanzamos a la siguiente noche
            setState(() {
              nocheActual++;
              esNoche = true;
              _generarSecuencia();
              pasoActual = 0;
            });

            // 👇 Mostrar inicio de la noche
            if (nocheActual == 1) {
              await _mostrarCambioDeFase('Inicia Primera Noche');
            } else {
              await _mostrarCambioDeFase('Inicia Noche $nocheActual');
            }
          },
        );
      }
    }
  }

  Future<void> _eliminarJugador(
    int indexVictima, {
    String causa = 'desconocida',
  }) async {
    final nombreVictima = widget.jugadores[indexVictima];
    jugadoresMuertos.add(indexVictima);
    relaciones.removeWhere((rol, lista) => lista.contains(nombreVictima));
    lobosFlow = lobosFlow.copyWith(victimaIndex: null);

    if (alguacilIndex == indexVictima) {
      alguacilIndex = null;
    }

    // 👇 Mostrar AlertDialog narrando la muerte
    String mensaje;
    switch (causa) {
      case 'lobos':
        mensaje = 'Los hombres lobos se han comido a $nombreVictima';
        break;
      case 'cupido':
        mensaje = '$nombreVictima murió por amor, tras la flecha de Cupido';
        break;
      case 'linchamiento':
        mensaje = '$nombreVictima fue linchado por la aldea';
        break;
      default:
        mensaje = '$nombreVictima ha muerto';
    }

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Muerte en la aldea'),
          content: Text(mensaje),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );

    // Lógica de Cupido: si muere un enamorado, muere el otro también
    if (cupidoFlow.isEnamorado(indexVictima)) {
      final otroIndex = (indexVictima == cupidoFlow.primerEnamoradoIndex)
          ? cupidoFlow.segundoEnamoradoIndex
          : cupidoFlow.primerEnamoradoIndex;

      if (otroIndex != null && !jugadoresMuertos.contains(otroIndex)) {
        await _eliminarJugador(otroIndex, causa: 'cupido');
      }
    }

    // Lógica del Niño Salvaje: si muere su modelo, se transforma en lobo
    if (ninoFlow.modeloIndex == indexVictima && !ninoFlow.transformado) {
      ninoFlow = ninoFlow.copyWith(transformado: true);

      // Cambiar su rol a Lobo Común (usar el nombre exacto del catálogo)
      final rolLobo = resolveRolByName('Hombres Lobo Comunes', widget.rolesSeleccionados);
      rolesAsignados[ninoFlow.ninoIndex!] = rolLobo;

      mostrarNotificacionArriba(
        context,
        '${widget.jugadores[ninoFlow.ninoIndex!]} se transforma en Lobo Común',
      );
    }
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
          updateCupido: (f) => setState(() => cupidoFlow = f),
          updateNino: (f) => setState(() => ninoFlow = f),
          updateVidente: (f) => setState(() => videnteFlow = f),
          updateLobos: (f) => setState(() => lobosFlow = f),
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
          updateAlguacil: (i) => setState(() => alguacilIndex = i),
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
              jugadoresMuertos: jugadoresMuertos,
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
