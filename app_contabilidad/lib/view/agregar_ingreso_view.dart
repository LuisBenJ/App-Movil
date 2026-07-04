import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';

class AgregarIngresoView extends StatefulWidget {
  @override
  _AgregarIngresoViewState createState() => _AgregarIngresoViewState();
}

class _AgregarIngresoViewState extends State<AgregarIngresoView> {
  final TextEditingController ingresoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Agregar ingreso")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: ingresoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Ingreso",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final ingreso = double.tryParse(ingresoController.text);

                if (ingreso == null) return;

                vm.setIngreso(ingreso);

                Navigator.pop(context);
              },
              child: Text("Guardar ingreso"),
            )
          ],
        ),
      ),
    );
  }
}