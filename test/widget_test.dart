import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prestamos_libros/screens/home_screen.dart';
import 'package:prestamos_libros/screens/registro_screen.dart';

void main() {
  Widget createApp() => const MaterialApp(home: HomeScreen());

  testWidgets('muestra las acciones principales', (tester) async {
    await tester.pumpWidget(createApp());

    expect(find.text('Control de préstamos'), findsOneWidget);
    expect(find.text('Registrar préstamo'), findsOneWidget);
    expect(find.text('Ver préstamos'), findsOneWidget);
  });

  testWidgets('abre el formulario para registrar un préstamo', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.tap(find.text('Registrar préstamo'));
    await tester.pumpAndSettle();

    expect(find.byType(RegistroScreen), findsOneWidget);
    expect(find.text('Libro *'), findsOneWidget);
    expect(find.text('Prestado a *'), findsOneWidget);
  });
}
