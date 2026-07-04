import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';

class ConfiguracionView extends StatefulWidget {
  @override
  _ConfiguracionViewState createState() => _ConfiguracionViewState();
}

class _ConfiguracionViewState extends State<ConfiguracionView> {
  late final TextEditingController ingresoController;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<GastoViewModel>(context, listen: false);
    ingresoController = TextEditingController(
      text: vm.ingreso == 0 ? '' : vm.ingreso.toString(),
    );
  }

  @override
  void dispose() {
    ingresoController.dispose();
    super.dispose();
  }

  void _guardarIngreso(GastoViewModel vm) {
    final ingreso = double.tryParse(ingresoController.text);
    if (ingreso == null) return;

    vm.setIngreso(ingreso);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ingreso mensual actualizado")),
    );
  }

  void _confirmarReseteo(GastoViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Resetear datos"),
        content: Text(
          "Esta acción eliminará todos los gastos y el ingreso mensual registrados. ¿Deseas continuar?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              vm.resetearDatos();
              ingresoController.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Todos los datos fueron eliminados")),
              );
            },
            child: Text(
              "Resetear",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Configuración")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Ingreso mensual",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ingresoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Ingreso",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _guardarIngreso(vm),
              child: Text("Guardar ingreso"),
            ),

            SizedBox(height: 40),
            Divider(),
            SizedBox(height: 20),

            Text(
              "Datos de la aplicación",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _confirmarReseteo(vm),
              child: Text("Resetear todos los datos"),
            ),
          ],
        ),
      ),
    );
  }
}
