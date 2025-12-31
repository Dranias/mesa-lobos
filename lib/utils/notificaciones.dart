import 'package:flutter/material.dart';

void mostrarNotificacionArriba(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  ScaffoldMessenger.of(context).clearMaterialBanners();
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      content: Text(mensaje),
      backgroundColor: Colors.black87,
      contentTextStyle: const TextStyle(color: Colors.white),
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
