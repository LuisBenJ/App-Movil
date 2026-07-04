import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';
import '../model/gasto.dart';
import 'agregar_gasto_view.dart';
import 'agregar_ingreso_view.dart';
import 'desglose_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Contabilidad")),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            "Ingreso: ${vm.ingreso}",
            style: TextStyle(fontSize: 22),
          ),

          Text(
            "Total de gastos: ${vm.totalGastos}",
            style: TextStyle(fontSize: 18),
          ),

          Text(
            "Restante: ${vm.saldo}",
            style: TextStyle(fontSize: 18),
          ),

          SizedBox(height: 20),



          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgregarIngresoView(),
                ),
              );
            },
            child: Text("Agregar ingreso"),
          ),

          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DesgloseView(),
                ),
              );
            },
            child: Text("Ver desglose de gastos"),
          ),
        ],
      ),

      // 👇 AQUÍ ESTÁ EL BOTÓN
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarGastoView(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}