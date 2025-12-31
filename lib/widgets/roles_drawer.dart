import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../roles/bruja.dart'; // 👈 importa el flujo de la bruja

/// Drawer lateral que muestra:
/// - Qué jugador tiene qué rol (usando la imagen del rol).
/// - Relaciones especiales (Cupido, Niño Salvaje, etc.).
/// - Estado de la Bruja y sus pociones.
class RolesDrawer extends StatelessWidget {
  final Map<int, Rol> rolesAsignados; // indexJugador -> Rol
  final Map<String, List<String>> relaciones; // nombreRol -> [actor, objetivo]
  final List<String> jugadores; // nombres en orden
  final List<Rol?> rolesIniciales; // roles seleccionados al inicio
  final BrujaFlow brujaFlow; // 👈 nuevo: estado de la bruja

  const RolesDrawer({
    super.key,
    required this.rolesAsignados,
    required this.relaciones,
    required this.jugadores,
    required this.rolesIniciales,
    required this.brujaFlow,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Roles en juego',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          // Lista de jugadores con su rol inicial y/o asignado
          ...List.generate(jugadores.length, (index) {
            final jugador = jugadores[index];
            final rolInicial = rolesIniciales.length > index
                ? rolesIniciales[index]
                : null;
            final rolAsignado = rolesAsignados[index];

            final rol = rolAsignado ??
                rolInicial ??
                Rol(
                  nombre: 'Aldeano',
                  descripcion: 'Sin poder especial',
                  objetivo: 'Sobrevivir',
                  imagen: 'assets/roles/aldeano.png',
                );

            final revelado = rolAsignado != null;

            return ListTile(
              leading: Image.asset(rol.imagen, width: 56, height: 56),
              title: Text(jugador),
              subtitle: Text(
                'Rol: ${rol.nombre}${revelado ? "." : ""}',
              ),
            );
          }),

          const SizedBox(height: 8),
          const Text(
            'Relaciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          if (relaciones.isEmpty)
            const ListTile(
              title: Text('Sin relaciones registradas aún'),
              subtitle: Text(
                'Se mostrarán aquí cuando se definan durante la narración.',
              ),
            )
          else
            ...relaciones.entries.map((entry) {
              final rolNombre = entry.key;
              final lista = entry.value;

              String title = rolNombre;
              String subtitle;

              switch (rolNombre) {
                case 'Cupido':
                  subtitle = lista.length >= 2
                      ? 'Vinculado: ${lista[0]} con ${lista[1]}'
                      : 'Vinculado: relación incompleta';
                  break;
                case 'Niño Salvaje':
                  subtitle = lista.length >= 2
                      ? 'Modelo: ${lista[0]} admira a ${lista[1]}'
                      : 'Modelo: relación incompleta';
                  break;
                default:
                  subtitle = lista.join(' • ');
              }

              String? imagenRol;
              try {
                final entrada = rolesAsignados.entries.firstWhere(
                  (e) => e.value.nombre == rolNombre,
                  orElse: () => MapEntry(
                    -1,
                    Rol(nombre: '', descripcion: '', objetivo: '', imagen: ''),
                  ),
                );
                if (entrada.key != -1) imagenRol = entrada.value.imagen;
              } catch (_) {
                imagenRol = null;
              }

              return ListTile(
                leading: imagenRol != null && imagenRol!.isNotEmpty
                    ? Image.asset(imagenRol!, width: 56, height: 56)
                    : const Icon(Icons.link, size: 40),
                title: Text(title),
                subtitle: Text(subtitle),
              );
            }),

          const SizedBox(height: 8),
          const Text(
            'Bruja',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          if (brujaFlow.brujaAsignada) ...[
            ListTile(
              leading: Image.asset(
                'assets/roles/pocion_vida.png',
                width: 32,
                height: 32,
                color: brujaFlow.pocionVidaUsada ? Colors.grey : null,
              ),
              title: const Text('Poción de vida'),
              subtitle: Text(
                brujaFlow.pocionVidaUsada
                    ? 'Usada en ${brujaFlow.pocionVidaObjetivo != null ? jugadores[brujaFlow.pocionVidaObjetivo!] : 'nadie'}'
                    : 'Disponible',
              ),
            ),
            ListTile(
              leading: Image.asset(
                'assets/roles/pocion_muerte.png',
                width: 32,
                height: 32,
                color: brujaFlow.pocionMuerteUsada ? Colors.grey : null,
              ),
              title: const Text('Poción de muerte'),
              subtitle: Text(
                brujaFlow.pocionMuerteUsada
                    ? 'Usada en ${brujaFlow.pocionMuerteObjetivo != null ? jugadores[brujaFlow.pocionMuerteObjetivo!] : 'nadie'}'
                    : 'Disponible',
              ),
            ),
          ] else
            const ListTile(
              title: Text('Bruja no asignada'),
              subtitle: Text('Se mostrará aquí cuando despierte en la narración.'),
            ),
        ],
      ),
    );
  }
}
