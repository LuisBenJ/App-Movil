import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';
import '../widgets/responsive_body.dart';
import '../widgets/summary_card.dart';
import 'agregar_gasto_view.dart';
import 'desglose_view.dart';
import 'estadisticas_view.dart';
import 'configuracion_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Contabilidad"),
      ),

      // 📂 MENÚ LATERAL IZQUIERDO (icono hamburguesa automático)
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: colorScheme.primary),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.onPrimary.withOpacity(0.15),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Contabilidad",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bar_chart_rounded),
                      title: const Text("Estadísticas"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
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
                      leading: const Icon(Icons.settings_rounded),
                      title: const Text("Configuración"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
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
            ],
          ),
        ),
      ),

      body: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Resumen del mes",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // 💳 TARJETAS DE RESUMEN
            // En tablets/web se muestran en fila; en celular, en columna.
            isTablet
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: "Ingreso mensual",
                          value: "\$${vm.ingreso.toStringAsFixed(2)}",
                          icon: Icons.savings_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          label: "Total de gastos",
                          value: "\$${vm.totalGastos.toStringAsFixed(2)}",
                          icon: Icons.trending_down_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          label: "Saldo restante",
                          value: "\$${vm.saldo.toStringAsFixed(2)}",
                          icon: Icons.account_balance_wallet_rounded,
                          valueColor: vm.saldo >= 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SummaryCard(
                        label: "Ingreso mensual",
                        value: "\$${vm.ingreso.toStringAsFixed(2)}",
                        icon: Icons.savings_rounded,
                      ),
                      const SizedBox(height: 14),
                      SummaryCard(
                        label: "Total de gastos",
                        value: "\$${vm.totalGastos.toStringAsFixed(2)}",
                        icon: Icons.trending_down_rounded,
                      ),
                      const SizedBox(height: 14),
                      SummaryCard(
                        label: "Saldo restante",
                        value: "\$${vm.saldo.toStringAsFixed(2)}",
                        icon: Icons.account_balance_wallet_rounded,
                        valueColor: vm.saldo >= 0
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ],
                  ),

            const SizedBox(height: 28),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DesgloseView(),
                  ),
                );
              },
              icon: const Icon(Icons.receipt_long_rounded),
              label: const Text("Ver desglose de gastos"),
            ),
          ],
        ),
      ),

      // 👇 BOTÓN AGREGAR GASTO
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarGastoView(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Nuevo gasto"),
      ),
    );
  }
}
