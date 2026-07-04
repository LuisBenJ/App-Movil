
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';
import '../model/gasto.dart';

class AgregarGastoView extends StatefulWidget {
  @override
  _AgregarGastoViewState createState() => _AgregarGastoViewState();
}

class _AgregarGastoViewState extends State<AgregarGastoView> {
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Agregar gasto")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 💰 INPUT CANTIDAD
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Cantidad",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // 📝 INPUT DESCRIPCIÓN
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // ✅ BOTÓN GUARDAR
            ElevatedButton(
              onPressed: () {
                final cantidad = double.tryParse(cantidadController.text);
                final descripcion = descripcionController.text.trim();

                if (cantidad == null || descripcion.isEmpty) return;

                vm.agregarGasto(
                  Gasto(
                    descripcion: descripcion,
                    cantidad: cantidad,
                    fecha: DateTime.now(),
                  ),
                );

                Navigator.pop(context);
              },
              child: Text("Guardar gasto"),
            )
          ],
        ),
      ),
    );
  }
}
