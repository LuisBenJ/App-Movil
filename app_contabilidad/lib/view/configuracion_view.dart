import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';
import '../widgets/responsive_body.dart';

class ConfiguracionView extends StatefulWidget {
  @override
  _ConfiguracionViewState createState() => _ConfiguracionViewState();
}

class _ConfiguracionViewState extends State<ConfiguracionView> {
  final _formKey = GlobalKey<FormState>();
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
    if (!_formKey.currentState!.validate()) return;

    final ingreso = double.parse(ingresoController.text);
    vm.setIngreso(ingreso);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ingreso mensual actualizado")),
    );
  }

  void _confirmarReseteo(GastoViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
        title: Text("Resetear datos"),
        content: Text(
          "Esta acción eliminará todos los gastos y el ingreso mensual registrados. ¿Deseas continuar?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
            ),
            onPressed: () {
              vm.resetearDatos();
              ingresoController.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Todos los datos fueron eliminados")),
              );
            },
            child: Text("Resetear"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Configuración")),
      body: ResponsiveBody(
        maxWidth: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 💰 SECCIÓN INGRESO MENSUAL
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.savings_rounded,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 10),
                          Text(
                            "Ingreso mensual",
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: ingresoController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: "Ingreso",
                          prefixIcon: Icon(Icons.attach_money_rounded),
                        ),
                        validator: (value) {
                          final parsed = double.tryParse(value ?? '');
                          if (parsed == null || parsed < 0) {
                            return "Ingresa un monto válido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _guardarIngreso(vm),
                        icon: const Icon(Icons.check_rounded),
                        label: const Text("Guardar ingreso"),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🗑️ SECCIÓN DATOS
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.delete_forever_rounded,
                            color: Colors.red.shade700),
                        const SizedBox(width: 10),
                        Text(
                          "Datos de la aplicación",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Elimina permanentemente todos los gastos e ingresos guardados en este dispositivo.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _confirmarReseteo(vm),
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text("Resetear todos los datos"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
