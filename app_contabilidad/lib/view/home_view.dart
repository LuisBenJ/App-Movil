import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';
import '../model/gasto.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Contabilidad")),

      body: Column(
        children: [
          Text("Ingreso: ${vm.ingreso}"),
          Text("Gastos: ${vm.totalGastos}"),
          Text("Saldo: ${vm.saldo}"),

          Expanded(
            child: ListView.builder(
              itemCount: vm.gastos.length,
              itemBuilder: (context, index) {
                final gasto = vm.gastos[index];
                return ListTile(
                  title: Text(gasto.categoria),
                  subtitle: Text("${gasto.cantidad}"),
                );
              },
            ),
          ),
        ],
      ),

      // 👇 AQUÍ ESTÁ EL BOTÓN
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          vm.agregarGasto(
            Gasto(
              categoria: "Comida",
              cantidad: 50,
              fecha: DateTime.now(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}