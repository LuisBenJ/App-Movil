import 'package:flutter/material.dart';
import '../model/gasto.dart';

class GastoViewModel extends ChangeNotifier {
  List<Gasto> _gastos = [];
  double ingreso = 0;

  List<Gasto> get gastos => _gastos;

  void agregarGasto(Gasto gasto) {
    _gastos.add(gasto);
    notifyListeners();
  }

  void setIngreso(double value) {
    ingreso = value;
    notifyListeners();
  }

  double get totalGastos {
    return _gastos.fold(0, (sum, g) => sum + g.cantidad);
  }

  double get saldo {
    return ingreso - totalGastos;
  }

  void resetearDatos() {
    _gastos = [];
    ingreso = 0;
    notifyListeners();
  }
}