import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/gasto_viewmodel.dart';
import 'view/home_view.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GastoViewModel(),
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
