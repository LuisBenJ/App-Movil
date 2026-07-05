import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';
import '../model/gasto.dart';
import '../widgets/responsive_body.dart';
import '../widgets/summary_card.dart';

class DesgloseView extends StatelessWidget {

  String _formatFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return "$dia/$mes/$anio · $hora:$minuto";
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    double total = vm.totalGastos;
    double restante = vm.saldo;

    final gastosOrdenados = List<Gasto>.of(vm.gastos)
      ..sort((a, b) => b.fecha.compareTo(a.fecha));

    return Scaffold(
      appBar: AppBar(title: Text("Desglose de gastos")),
      body: ResponsiveBody(
        maxWidth: 720,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔝 RESUMEN SUPERIOR
            isTablet
                ? Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: "Total gastado",
                          value: "\$${total.toStringAsFixed(2)}",
                          icon: Icons.trending_down_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          label: "Dinero restante",
                          value: "\$${restante.toStringAsFixed(2)}",
                          icon: Icons.account_balance_wallet_rounded,
                          valueColor: restante >= 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SummaryCard(
                        label: "Total gastado",
                        value: "\$${total.toStringAsFixed(2)}",
                        icon: Icons.trending_down_rounded,
                      ),
                      const SizedBox(height: 14),
                      SummaryCard(
                        label: "Dinero restante",
                        value: "\$${restante.toStringAsFixed(2)}",
                        icon: Icons.account_balance_wallet_rounded,
                        valueColor: restante >= 0
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ],
                  ),

            const SizedBox(height: 12),
            Divider(),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Historial de gastos",
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),

            // 📋 LISTA DE GASTOS
            Expanded(
              child: gastosOrdenados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 48,
                            color: theme.colorScheme.outlineVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No hay gastos registrados",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: gastosOrdenados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final gasto = gastosOrdenados[index];

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.shopping_bag_rounded,
                                    color: theme.colorScheme.onSecondaryContainer,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        gasto.descripcion,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _formatFecha(gasto.fecha),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "\$${gasto.cantidad.toStringAsFixed(2)}",
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
