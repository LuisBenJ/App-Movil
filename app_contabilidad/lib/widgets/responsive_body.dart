import 'package:flutter/material.dart';

/// Breakpoints simples usados en toda la app.
class AppBreakpoints {
  static const double tablet = 600;
  static const double desktop = 1000;

  static bool isTablet(double width) => width >= tablet;
  static bool isDesktop(double width) => width >= desktop;
}

/// Envuelve el contenido de una pantalla para que:
/// - En celulares ocupe todo el ancho disponible.
/// - En tablets/web se centre y limite su ancho máximo,
///   evitando líneas de texto o formularios excesivamente anchos.
///
/// Uso:
/// ```dart
/// body: ResponsiveBody(
///   child: Column(...),
/// )
/// ```
class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.maxWidth = 640,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Calcula cuántas columnas usar según el ancho disponible,
/// útil para grids de tarjetas (ej. resumen financiero).
int responsiveColumns(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (AppBreakpoints.isDesktop(width)) return 3;
  if (AppBreakpoints.isTablet(width)) return 2;
  return 1;
}
