import 'package:flutter/material.dart';

class EstadisticasView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Estadísticas")),
      body: Center(
        child: Text(
          "Próximamente: estadísticas basadas en tus datos",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
