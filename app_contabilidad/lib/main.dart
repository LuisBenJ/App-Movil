import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/gasto_viewmodel.dart';
import 'view/home_view.dart';

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
      home: HomeView(),
    );
  }
}