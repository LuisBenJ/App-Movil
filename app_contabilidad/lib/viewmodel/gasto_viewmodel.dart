import 'package:flutter/material.dart';
import '../model/gasto.dart';
import '../data/local_storage_service.dart';

class GastoViewModel extends ChangeNotifier {
  final LocalStorageService _storage;

  List<Gasto> _gastos = [];
  double ingreso = 0;

  /// Al crear el ViewModel se cargan de inmediato los datos ya
  /// guardados localmente (Hive), por lo que la información
  /// persiste entre sesiones y funciona sin conexión a internet.
  GastoViewModel(this._storage) {
    _gastos = _storage.loadGastos();
    ingreso = _storage.loadIngreso();
  }

  List<Gasto> get gastos => _gastos;

  void agregarGasto(Gasto gasto) {
    _gastos.add(gasto);
    _storage.addGasto(gasto);
    notifyListeners();
  }

  void setIngreso(double value) {
    ingreso = value;
    _storage.saveIngreso(value);
    notifyListeners();
  }

  double get totalGastos {
    return _gastos.fold(0, (sum, g) => sum + g.cantidad);
  }

  double get saldo {
    return ingreso - totalGastos;
  }

  /// Suma de gastos agrupados por mes (clave = primer día de cada mes).
  /// Se usa para la gráfica de columnas en Estadísticas.
  Map<DateTime, double> get gastosPorMes {
    final Map<DateTime, double> data = {};

    for (var gasto in _gastos) {
      final clave = DateTime(gasto.fecha.year, gasto.fecha.month);
      data[clave] = (data[clave] ?? 0) + gasto.cantidad;
    }

    return data;
  }

  Future<void> resetearDatos() async {
    _gastos = [];
    ingreso = 0;
    notifyListeners();
    await _storage.clearAll();
  }
}
