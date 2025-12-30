// screens/configuracion_jugadores.dart
import 'package:flutter/material.dart';
import '../screens/mesa_screen.dart';
import '../data/roles.dart';

/// Pantalla 1: nombres de jugadores (mínimo 6), con opción para agregar más
class ConfiguracionJugadoresScreen extends StatefulWidget {
  const ConfiguracionJugadoresScreen({super.key});

  @override
  State<ConfiguracionJugadoresScreen> createState() =>
      _ConfiguracionJugadoresScreenState();
}

class _ConfiguracionJugadoresScreenState
    extends State<ConfiguracionJugadoresScreen> {
  final List<TextEditingController> _controllers = [];
  static const int _minJugadores = 6;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _minJugadores; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void _agregarJugador() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _continuar() {
    final jugadores = _controllers
        .map((c) => c.text.trim())
        .where((nombre) => nombre.isNotEmpty)
        .toList();

    if (jugadores.length < _minJugadores) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debes ingresar al menos $_minJugadores jugadores'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeleccionRolesScreen(jugadores: jugadores),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jugadoresIngresados = _controllers.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Jugadores')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Jugador ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _agregarJugador,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Agregar jugador'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: jugadoresIngresados >= _minJugadores
                        ? _continuar
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pantalla 2: selección de roles (mínimo 3, máximo n = jugadores.length)
/// Cada slot de rol se selecciona tocando un botón con la imagen de Aldeano.
/// Al tocarlo, se abre un modal con lista de roles (ícono, nombre, objetivo).
class SeleccionRolesScreen extends StatefulWidget {
  final List<String> jugadores;
  const SeleccionRolesScreen({super.key, required this.jugadores});

  @override
  State<SeleccionRolesScreen> createState() => _SeleccionRolesScreenState();
}

class _SeleccionRolesScreenState extends State<SeleccionRolesScreen> {
  static const int _minRoles = 3;
  late int _numRoles;
  late List<Rol?> _rolesSeleccionados;

  @override
  void initState() {
    super.initState();
    _numRoles = _minRoles;
    _rolesSeleccionados = List<Rol?>.filled(_numRoles, null, growable: true);
  }

  void _ajustarNumeroRoles(int nuevo) {
    setState(() {
      _numRoles = nuevo;
      // Reajustar lista manteniendo selecciones existentes hasta donde se pueda
      if (_rolesSeleccionados.length < _numRoles) {
        _rolesSeleccionados.addAll(
          List<Rol?>.filled(_numRoles - _rolesSeleccionados.length, null),
        );
      } else if (_rolesSeleccionados.length > _numRoles) {
        _rolesSeleccionados = _rolesSeleccionados.sublist(0, _numRoles);
      }
    });
  }

  Future<void> _abrirSelectorRol(int index) async {
    final seleccionado = await showModalBottomSheet<Rol?>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.7,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Selecciona un rol',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: roles.length,
                    itemBuilder: (context, i) {
                      final rol = roles[i];
                      return ListTile(
                        leading: Image.asset(
                          rol.imagen,
                          width: 100,
                          height: 100,
                        ),
                        title: Text(rol.nombre),
                        subtitle: Text(
                          rol.objetivo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Navigator.pop(ctx, rol),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (seleccionado != null) {
      setState(() {
        _rolesSeleccionados[index] = seleccionado;
      });
    }
  }

  void _iniciarPartida() {
    // Se puede iniciar aunque haya roles sin seleccionar; usamos Aldeano por defecto en MesaScreen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MesaScreen(
          jugadores: widget.jugadores,
          rolesSeleccionados: _rolesSeleccionados,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxRoles = widget.jugadores.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Roles (3 a n)')),
      body: Column(
        children: [
          // Selector de número de roles (3..n)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text('Número de roles:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _numRoles,
                  items: List.generate(
                    (maxRoles - _minRoles + 1).clamp(0, maxRoles),
                    (i) {
                      final value = _minRoles + i;
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      );
                    },
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      _ajustarNumeroRoles(val);
                    }
                  },
                ),
              ],
            ),
          ),

          // Grid de botones de rol (cada botón abre el modal de selección)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4, // menos separación horizontal
                mainAxisSpacing: 4, // menos separación vertical
                childAspectRatio:
                    1.2, // más ancho que alto → menos espacio entre filas
              ),

              itemCount: _numRoles,
              itemBuilder: (context, index) {
                final rol = _rolesSeleccionados[index];
                final imagen = rol?.imagen ?? 'assets/roles/aldeano.png';
                final nombre = rol?.nombre ?? 'Aldeano';

                return GestureDetector(
                  onTap: () => _abrirSelectorRol(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // La imagen es el botón
                      Image.asset(
                        imagen,
                        width: 70, // antes 80
                        height: 70, // antes 80
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 6),
                      Text(
                        nombre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Botón iniciar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _iniciarPartida,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar partida'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
