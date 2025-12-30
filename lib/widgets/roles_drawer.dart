import 'package:flutter/material.dart';
import '../data/roles.dart';

/// Drawer lateral que muestra:
/// - Qué jugador tiene qué rol (usando la imagen del rol).
/// - Relaciones especiales (Cupido, Niño Salvaje, etc.) tomadas del mapa [relaciones].
class RolesDrawer extends StatelessWidget {
  final Map<int, Rol> rolesAsignados; // indexJugador -> Rol
  final Map<String, List<String>>
  relaciones; // nombreRol -> [actor, objetivo] (o más)
  final List<String> jugadores; // nombres en orden

  const RolesDrawer({
    super.key,
    required this.rolesAsignados,
    required this.relaciones,
    required this.jugadores,
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

          // Lista de jugadores con su rol asignado
          ...rolesAsignados.entries.map((e) {
            final index = e.key;
            final rol = e.value;
            final jugador = jugadores[index];

            return ListTile(
              leading: Image.asset(rol.imagen, width: 36, height: 36),
              title: Text(jugador),
              subtitle: Text('Rol: ${rol.nombre}'),
            );
          }),

          const SizedBox(height: 8),
          const Text(
            'Relaciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          // Relaciones especiales (Cupido, Niño Salvaje, etc.)
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
              final lista = entry.value; // Ej: [actor, objetivo]

              // Mensajes amigables por rol conocido
              String title = rolNombre;
              String subtitle;

              switch (rolNombre) {
                case 'Cupido':
                  // Esperamos: [cupido, pareja]
                  subtitle = lista.length >= 2
                      ? 'Vinculado: ${lista[0]} con ${lista[1]}'
                      : 'Vinculado: relación incompleta';
                  break;
                case 'Niño Salvaje':
                  // Esperamos: [niño, modelo]
                  subtitle = lista.length >= 2
                      ? 'Modelo: ${lista[0]} admira a ${lista[1]}'
                      : 'Modelo: relación incompleta';
                  break;
                default:
                  // Para roles genéricos o relaciones múltiples
                  subtitle = lista.join(' • ');
              }

              // Intentar cargar imagen del rol si está en rolesAsignados, si no, usar un ícono por defecto
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
                    ? Image.asset(imagenRol!, width: 36, height: 36)
                    : const Icon(Icons.link, size: 28),
                title: Text(title),
                subtitle: Text(subtitle),
              );
            }),
        ],
      ),
    );
  }
}
