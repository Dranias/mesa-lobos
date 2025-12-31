import 'package:flutter/material.dart';
import '../data/roles.dart';
import '../utils/notificaciones.dart';

/// Límites por rol (puedes ampliar este mapa según tus reglas).
/// Ejemplo: 'Lobo Feroz' máximo 2.
const Map<String, int> kRoleLimits = {
  'Lobo Feroz': 2,
};

/// Devuelve la imagen fallback derivada del nombre del rol (cuando no existe en el catálogo).
String _fallbackImageFromName(String nombre) {
  return 'assets/roles/${nombre.toLowerCase().replaceAll(" ", "_")}.png';
}

/// Busca y devuelve el Rol por nombre dentro del catálogo (rolesSeleccionados).
/// Si no existe (p. ej. Alguacil), crea un Rol básico con su imagen por convención.
Rol resolveRolByName(String nombre, List<Rol?> catalogo) {
  final match = catalogo
      .where((r) => r != null && r!.nombre == nombre)
      .map((r) => r!)
      .toList();
  if (match.isNotEmpty) return match.first;

  return Rol(
    nombre: nombre,
    descripcion: '',
    objetivo: '',
    imagen: _fallbackImageFromName(nombre),
  );
}

/// Cuenta cuántos jugadores tienen asignado un rol específico.
int countAssignedRole(Map<int, Rol> rolesAsignados, String nombreRol) {
  return rolesAsignados.values.where((r) => r.nombre == nombreRol).length;
}

/// Verifica si aún se puede asignar el rol según sus límites configurados.
bool canAssignRole(
  String nombreRol,
  Map<int, Rol> rolesAsignados, {
  Map<String, int> roleLimits = kRoleLimits,
}) {
  final limit = roleLimits[nombreRol];
  if (limit == null) return true; // sin límite
  final current = countAssignedRole(rolesAsignados, nombreRol);
  return current < limit;
}

/// Asigna un rol genérico al jugador `index`, respetando límites.
/// Muestra SnackBar opcionalmente si se provee [context].
/// Devuelve el Rol asignado (o null si no se pudo asignar por límite).
Rol? assignGenericRole({
  required int index,
  required String nombreRol,
  required List<String> jugadores,
  required Map<int, Rol> rolesAsignados,
  required List<Rol?> catalogo,
  BuildContext? context,
  Map<String, int> roleLimits = kRoleLimits,
}) {
  if (!canAssignRole(nombreRol, rolesAsignados, roleLimits: roleLimits)) {
    if (context != null) {
      final max = roleLimits[nombreRol];
      mostrarNotificacionArriba(context, 'Límite alcanzado para $nombreRol (máximo $max).');
    }
    return null;
  }

  final rolObj = resolveRolByName(nombreRol, catalogo);
  rolesAsignados[index] = rolObj;

  if (context != null) {
    mostrarNotificacionArriba(context, '${jugadores[index]} ahora es ${rolObj.nombre}');
  }

  return rolObj;
}
