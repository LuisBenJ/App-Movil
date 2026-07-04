import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';

class DesgloseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);
    final data = vm.gastosPorCategoria;

    double total = vm.totalGastos;
    double restante = vm.saldo;

    return Scaffold(
      appBar: AppBar(title: Text("Desglose de gastos")),

      body: Column(
        children: [

          // 🔝 TOTAL ARRIBA
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Total gastado",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "\$${total.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Divider(),

          // 📊 LISTA DE CATEGORÍAS
          Expanded(
            child: data.isEmpty
                ? Center(child: Text("No hay gastos registrados"))
                : ListView(
              children: data.entries.map((entry) {
                double porcentaje =
                total == 0 ? 0 : entry.value / total;

                return Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        // 🧾 NOMBRE + MONTO
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\$${entry.value.toStringAsFixed(2)}",
                            ),
                          ],
                        ),

                        SizedBox(height: 5),

                        // 📊 PORCENTAJE
                        Text(
                          "${(porcentaje * 100).toStringAsFixed(1)}%",
                          style: TextStyle(fontSize: 12),
                        ),

                        SizedBox(height: 5),

                        // 📈 BARRA VISUAL
                        LinearProgressIndicator(
                          value: porcentaje,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Divider(),

          // 🔻 RESTANTE ABAJO
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Dinero restante",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "\$${restante.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: restante >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}