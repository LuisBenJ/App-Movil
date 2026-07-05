import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'viewmodel/gasto_viewmodel.dart';
import 'view/home_view.dart';
import 'theme/app_theme.dart';
import 'data/local_storage_service.dart';

void main() async {
  // Necesario porque usamos await antes de runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive y abre las "cajas" (boxes) donde se guardan
  // gastos e ingreso mensual. Todo esto es local al dispositivo,
  // no requiere internet.
  await Hive.initFlutter();
  final storage = LocalStorageService();
  await storage.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => GastoViewModel(storage),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contabilidad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeView(),
    );
  }
}
