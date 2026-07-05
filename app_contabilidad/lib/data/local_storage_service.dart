import 'package:hive_flutter/hive_flutter.dart';
import '../model/gasto.dart';

/// Servicio de persistencia local usando Hive.
///
/// Decisión de diseño: en lugar de crear un TypeAdapter con
/// build_runner (código generado), guardamos cada [Gasto] como un
/// Map<String, dynamic> con tipos primitivos (String, double, DateTime).
/// Hive soporta estos tipos de forma nativa sin necesidad de generar
/// adaptadores, lo cual simplifica el mantenimiento del proyecto.
///
/// Por qué Hive y no SQLite/SharedPreferences para este caso:
/// - SharedPreferences solo sirve para pares clave-valor simples
///   (bueno para "ingreso mensual", insuficiente para una lista
///   creciente de gastos con fecha y descripción).
/// - SQLite es ideal si más adelante necesitas consultas complejas
///   (filtrar por rango de fechas, sumar por mes, joins, etc.), pero
///   añade una capa de SQL/migraciones que no es necesaria todavía.
/// - Hive es NoSQL, basado en archivos binarios locales, muy rápido
///   para lecturas/escrituras simples como esta lista de gastos y el
///   ingreso mensual, y ya estaba como dependencia del proyecto.
class LocalStorageService {
  static const String _gastosBoxName = 'gastos_box';
  static const String _configBoxName = 'config_box';
  static const String _ingresoKey = 'ingreso_mensual';

  late Box _gastosBox;
  late Box _configBox;

  /// Debe llamarse una sola vez, antes de runApp(), y después de
  /// haber llamado Hive.initFlutter().
  Future<void> init() async {
    _gastosBox = await Hive.openBox(_gastosBoxName);
    _configBox = await Hive.openBox(_configBoxName);
  }

  /// Carga todos los gastos guardados en el dispositivo.
  List<Gasto> loadGastos() {
    return _gastosBox.values.map((raw) {
      final data = Map<String, dynamic>.from(raw as Map);
      return Gasto(
        descripcion: data['descripcion'] as String,
        cantidad: (data['cantidad'] as num).toDouble(),
        fecha: data['fecha'] as DateTime,
      );
    }).toList();
  }

  /// Persiste un nuevo gasto. Se guarda de inmediato, así que
  /// sobrevive a cierres de la app o falta de conexión (todo es
  /// local, no depende de internet).
  Future<void> addGasto(Gasto gasto) {
    return _gastosBox.add({
      'descripcion': gasto.descripcion,
      'cantidad': gasto.cantidad,
      'fecha': gasto.fecha,
    });
  }

  /// Carga el ingreso mensual guardado (0 si nunca se ha configurado).
  double loadIngreso() {
    final value = _configBox.get(_ingresoKey, defaultValue: 0.0);
    return (value as num).toDouble();
  }

  /// Persiste el ingreso mensual.
  Future<void> saveIngreso(double value) {
    return _configBox.put(_ingresoKey, value);
  }

  /// Elimina todos los datos locales (usado por "Resetear todos los datos").
  Future<void> clearAll() async {
    await _gastosBox.clear();
    await _configBox.clear();
  }
}
