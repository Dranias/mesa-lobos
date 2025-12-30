import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../data/reglas.dart';

// Widgets
import '../widgets/narrador_card.dart';
import '../widgets/mesa_jugadores.dart';
import '../widgets/roles_drawer.dart';

// Managers
import '../managers/roles_manager.dart';
import '../managers/relaciones_manager.dart';

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
  bool _esRolDeLobo(String rol) {
    return rol == 'Hombres Lobo Comunes' ||
        rol == 'Lobo Feroz' ||
        rol == 'Infecto Padre de todos los Lobos' ||
        rol == 'Hombre Lobo Albino' ||
        rol == 'Perro Lobo';
  }

  int nocheActual = 1;
  int pasoActual = 0;
  late List<Regla> secuencia;

  Map<int, Rol> rolesAsignados = {};
  Map<String, List<String>> relaciones = {};

  // Flujos especiales
  CupidoFlow cupidoFlow = CupidoFlow.reset();
  NinoSalvajeFlow ninoFlow = NinoSalvajeFlow.reset();

  // Vidente
  bool videnteAsignada = false;
  int? videnteObjetivoIndex;

  // Número máximo de lobos según selección inicial
  late int maxLobos;

  @override
  void initState() {
    super.initState();
    maxLobos = widget.rolesSeleccionados
        .where((r) => r?.nombre == 'Lobo Feroz')
        .length;
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

  void _finalizarAsignacionLobos() {
    for (int i = 0; i < widget.jugadores.length; i++) {
      if (rolesAsignados[i] == null) {
        final aldeano = resolveRolByName('Aldeano', widget.rolesSeleccionados);
        rolesAsignados[i] = aldeano;
      }
    }
  }

  void _siguientePaso() {
    setState(() {
      if (pasoActual < secuencia.length - 1) {
        pasoActual++;
        final regla = secuencia[pasoActual];

        // Cupido y Niño Salvaje solo en primera noche
        if (nocheActual > 1) {
          if (regla.rol == 'Cupido') pasoActual++;
          if (regla.rol == 'Niño Salvaje') pasoActual++;
        }

        // Reset de Vidente cada noche
        if (regla.rol != 'Vidente') {
          videnteAsignada = false;
          videnteObjetivoIndex = null;
        }

        // Al terminar asignación inicial de Hombres Lobo, convertir resto en Aldeanos
        if (_esRolDeLobo(regla.rol)) {
          _finalizarAsignacionLobos();
        }
      } else {
        nocheActual++;
        _generarSecuencia();
      }
    });
  }

  // Callbacks
  void _asignarCupido(int index) {
    if (nocheActual > 1 || cupidoFlow.cupidoAsignado) return;
    setState(() {
      cupidoFlow = assignCupido(
        index: index,
        jugadores: widget.jugadores,
        rolesAsignados: rolesAsignados,
        relaciones: relaciones,
        resolverRol: (nombre) =>
            resolveRolByName(nombre, widget.rolesSeleccionados),
        context: context,
      );
    });
  }

  void _seleccionarPareja(int index) {
    if (nocheActual > 1 || cupidoFlow.parejaAsignada) return;
    setState(() {
      cupidoFlow = selectPareja(
        index: index,
        cupidoIndex: cupidoFlow.cupidoIndex!,
        jugadores: widget.jugadores,
        relaciones: relaciones,
        context: context,
      );
    });
  }

  void _asignarNinoSalvaje(int index) {
    if (nocheActual > 1 || ninoFlow.ninoAsignado) return;
    setState(() {
      ninoFlow = assignNinoSalvaje(
        index: index,
        jugadores: widget.jugadores,
        rolesAsignados: rolesAsignados,
        relaciones: relaciones,
        resolverRol: (nombre) =>
            resolveRolByName(nombre, widget.rolesSeleccionados),
        context: context,
      );
    });
  }

  void _seleccionarModelo(int index) {
    if (nocheActual > 1 || ninoFlow.modeloAsignado) return;
    setState(() {
      ninoFlow = selectModelo(
        index: index,
        ninoIndex: ninoFlow.ninoIndex!,
        jugadores: widget.jugadores,
        relaciones: relaciones,
        context: context,
      );
    });
  }

  void _asignarVidente(int index) {
    if (videnteAsignada) return;
    if (rolesAsignados[index] != null) return;

    setState(() {
      // Asignar el rol de Vidente al jugador
      final videnteRol = resolveRolByName('Vidente', widget.rolesSeleccionados);
      rolesAsignados[index] = videnteRol;

      // Guardar a quién observa en esta noche
      videnteObjetivoIndex = index;
      videnteAsignada = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'La Vidente se asigna a ${widget.jugadores[index]} y observa su carta',
        ),
      ),
    );
  }

  void _asignarRolGenerico(int index, String nombreRol) {
    setState(() {
      if (nombreRol == 'Lobo Feroz') {
        final count = rolesAsignados.values
            .where((r) => r.nombre == 'Lobo Feroz')
            .length;
        if (count >= maxLobos) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ya se asignaron todos los Lobos Feroz'),
            ),
          );
          return;
        }
      }
      if (nombreRol == 'Vidente') {
        _asignarVidente(index);
        return;
      }
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
              cupidoIndex: cupidoFlow.cupidoIndex,
              parejaIndex: cupidoFlow.parejaIndex,
              cupidoAsignado: cupidoFlow.cupidoAsignado,
              parejaAsignada: cupidoFlow.parejaAsignada,
              ninoSalvajeIndex: ninoFlow.ninoIndex,
              modeloIndex: ninoFlow.modeloIndex,
              ninoSalvajeAsignado: ninoFlow.ninoAsignado,
              modeloAsignado: ninoFlow.modeloAsignado,
              onAsignarCupido: _asignarCupido,
              onSeleccionarPareja: _seleccionarPareja,
              onAsignarNino: _asignarNinoSalvaje,
              onSeleccionarModelo: _seleccionarModelo,
              onAsignarRolGenerico: _asignarRolGenerico,
            ),
          ),
          if (reglaActual != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: NarradorCard(
                  nocheActual: nocheActual,
                  pasoActual: pasoActual,
                  totalPasos: secuencia.length,
                  rolActivo: reglaActual.rol,
                  cupidoAsignado: cupidoFlow.cupidoAsignado,
                  parejaAsignada: cupidoFlow.parejaAsignada,
                  ninoSalvajeAsignado: ninoFlow.ninoAsignado,
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
