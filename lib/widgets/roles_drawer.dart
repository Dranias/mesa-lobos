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
  final List<Rol?> rolesIniciales; // roles seleccionados al inicio

  const RolesDrawer({
    super.key,
    required this.rolesAsignados,
    required this.relaciones,
    required this.jugadores,
    required this.rolesIniciales,
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

            // Si ya fue asignado en la narración, usamos ese; si no, mostramos el inicial
            final rol =
                rolAsignado ??
                rolInicial ??
                Rol(
                  nombre: 'Aldeano',
                  descripcion: 'Sin poder especial',
                  objetivo: 'Sobrevivir',
                  imagen: 'assets/roles/aldeano.png',
                );

            // Leyenda extra si ya fue revelado en la narración
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
                    ? Image.asset(imagenRol!, width: 56, height: 56)
                    : const Icon(Icons.link, size: 40),
                title: Text(title),
                subtitle: Text(subtitle),
              );
            }),
        ],
      ),
    );
  }
}
