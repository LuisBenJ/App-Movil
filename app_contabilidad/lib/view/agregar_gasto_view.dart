
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

  String categoriaSeleccionada = "Alimentación";

  final List<String> categorias = [
    "Alimentación",
    "Transporte",
    "Hogar",
    "Entretenimiento",
    "Educación",
    "Compras personales",
    "Salud",
    "Ahorro",
    "Otros"
  ];

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

            // 📂 DROPDOWN CATEGORÍAS
            DropdownButtonFormField<String>(
              value: categoriaSeleccionada,
              items: categorias.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  categoriaSeleccionada = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Categoría",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // ✅ BOTÓN GUARDAR
            ElevatedButton(
              onPressed: () {
                final cantidad = double.tryParse(cantidadController.text);

                if (cantidad == null) return;

                vm.agregarGasto(
                  Gasto(
                    categoria: categoriaSeleccionada,
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