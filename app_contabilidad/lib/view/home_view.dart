import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';
import 'agregar_gasto_view.dart';
import 'desglose_view.dart';
import 'estadisticas_view.dart';
import 'configuracion_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Contabilidad")),

      // 📂 MENÚ LATERAL DERECHO
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Menú",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text("Estadísticas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EstadisticasView(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configuración"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfiguracionView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

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

      // 👇 BOTÓN AGREGAR GASTO
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
