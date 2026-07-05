
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/gasto_viewmodel.dart';
import '../model/gasto.dart';
import '../widgets/responsive_body.dart';

class AgregarGastoView extends StatefulWidget {
  @override
  _AgregarGastoViewState createState() => _AgregarGastoViewState();
}

class _AgregarGastoViewState extends State<AgregarGastoView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  @override
  void dispose() {
    cantidadController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  void _guardar(GastoViewModel vm) {
    if (!_formKey.currentState!.validate()) return;

    final cantidad = double.parse(cantidadController.text);
    final descripcion = descripcionController.text.trim();

    vm.agregarGasto(
      Gasto(
        descripcion: descripcion,
        cantidad: cantidad,
        fecha: DateTime.now(),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GastoViewModel>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Agregar gasto")),
      body: ResponsiveBody(
        maxWidth: 520,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.receipt_long_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                "Registra un nuevo gasto",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                "La fecha se guarda automáticamente",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),

              // 💰 INPUT CANTIDAD
              TextFormField(
                controller: cantidadController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Cantidad",
                  prefixIcon: Icon(Icons.attach_money_rounded),
                ),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return "Ingresa una cantidad válida";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 📝 INPUT DESCRIPCIÓN
              TextFormField(
                controller: descripcionController,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 60,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  hintText: "Ej. Cena con amigos",
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingresa una descripción";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),

              // ✅ BOTÓN GUARDAR
              ElevatedButton.icon(
                onPressed: () => _guardar(vm),
                icon: const Icon(Icons.check_rounded),
                label: const Text("Guardar gasto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
