import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';

class DesgloseView extends StatelessWidget {

  String _formatFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return "$dia/$mes/$anio $hora:$minuto";
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);
    final gastos = vm.gastos;

    double total = vm.totalGastos;
    double restante = vm.saldo;

    // Mostrar los gastos más recientes primero
    final gastosOrdenados = List.of(gastos)
      ..sort((a, b) => b.fecha.compareTo(a.fecha));

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

          // 📋 LISTA DE GASTOS
          Expanded(
            child: gastosOrdenados.isEmpty
                ? Center(child: Text("No hay gastos registrados"))
                : ListView.builder(
              itemCount: gastosOrdenados.length,
              itemBuilder: (context, index) {
                final gasto = gastosOrdenados[index];

                return Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        // 🧾 DESCRIPCIÓN + MONTO
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                gasto.descripcion,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "\$${gasto.cantidad.toStringAsFixed(2)}",
                            ),
                          ],
                        ),

                        SizedBox(height: 5),

                        // 📅 FECHA
                        Text(
                          _formatFecha(gasto.fecha),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
