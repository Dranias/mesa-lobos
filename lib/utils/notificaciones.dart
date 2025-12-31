import 'package:flutter/material.dart';

void mostrarNotificacionArriba(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
      // Opcional: estilo
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 2),
    ),
  );
}
