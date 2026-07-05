import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodel/gasto_viewmodel.dart';
import '../widgets/responsive_body.dart';

/// Pantalla de estadísticas.
///
/// Todo se calcula 100% en el dispositivo a partir de los datos que
/// ya tienes guardados con Hive (no requiere ninguna API ni conexión
/// a internet). Muestra:
///  - Un pastel con la proporción de ingreso gastado vs. restante.
///  - Una gráfica de columnas con el total de gastos por mes.
class EstadisticasView extends StatelessWidget {
  static const List<String> _meses = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Estadísticas")),
      body: vm.gastos.isEmpty
          ? _EmptyState(theme: theme)
          : ResponsiveBody(
              maxWidth: 720,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _IngresoVsGastosCard(vm: vm, theme: theme),
                    const SizedBox(height: 28),
                    _GastosPorMesCard(vm: vm, theme: theme),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
    );
  }
}

/// 🥧 Gráfica de pastel: ingreso gastado vs. restante.
class _IngresoVsGastosCard extends StatelessWidget {
  final GastoViewModel vm;
  final ThemeData theme;

  const _IngresoVsGastosCard({required this.vm, required this.theme});

  @override
  Widget build(BuildContext context) {
    final gastado = vm.totalGastos;
    final restante = vm.saldo > 0 ? vm.saldo : 0.0;
    final tieneIngreso = vm.ingreso > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ingreso vs. gastos", style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              "Configura tu ingreso mensual en Configuración para verlo aquí.",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            if (!tieneIngreso)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    "Sin ingreso mensual configurado",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else ...[
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 42,
                    sections: [
                      PieChartSectionData(
                        value: gastado,
                        color: theme.colorScheme.error,
                        radius: 68,
                        title:
                            "${((gastado / vm.ingreso) * 100).clamp(0, 999).toStringAsFixed(0)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      PieChartSectionData(
                        value: restante,
                        color: theme.colorScheme.primary,
                        radius: 68,
                        title:
                            "${((restante / vm.ingreso) * 100).clamp(0, 100).toStringAsFixed(0)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Leyenda(
                    color: theme.colorScheme.error,
                    label: "Gastado (\$${gastado.toStringAsFixed(2)})",
                  ),
                  const SizedBox(width: 24),
                  _Leyenda(
                    color: theme.colorScheme.primary,
                    label: "Restante (\$${restante.toStringAsFixed(2)})",
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 📊 Gráfica de columnas: total de gastos por mes.
class _GastosPorMesCard extends StatelessWidget {
  final GastoViewModel vm;
  final ThemeData theme;

  const _GastosPorMesCard({required this.vm, required this.theme});

  @override
  Widget build(BuildContext context) {
    final entradas = vm.gastosPorMes.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Solo los últimos 6 meses con datos, para no saturar la gráfica.
    final ultimos =
        entradas.length > 6 ? entradas.sublist(entradas.length - 6) : entradas;

    final maxValor = ultimos.isEmpty
        ? 0.0
        : ultimos.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Gastos por mes", style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              "Últimos ${ultimos.length} mes(es) con movimientos",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 240,
              child: ultimos.isEmpty
                  ? Center(
                      child: Text(
                        "No hay datos suficientes",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        maxY: maxValor == 0 ? 10 : maxValor * 1.2,
                        alignment: BarChartAlignment.spaceAround,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= ultimos.length) {
                                  return const SizedBox.shrink();
                                }
                                final fecha = ultimos[idx].key;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    EstadisticasView._meses[fecha.month - 1],
                                    style: theme.textTheme.labelSmall,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIdx, rod, rodIdx) {
                              return BarTooltipItem(
                                "\$${rod.toY.toStringAsFixed(2)}",
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        barGroups: List.generate(ultimos.length, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: ultimos[i].value,
                                color: theme.colorScheme.primary,
                                width: 22,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Leyenda extends StatelessWidget {
  final Color color;
  final String label;

  const _Leyenda({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;

  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBody(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.insights_rounded,
                size: 48,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text("Aún no hay datos", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              "Registra algunos gastos para ver tus estadísticas aquí.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
