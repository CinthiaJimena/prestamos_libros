import 'package:flutter/material.dart';

import 'lista_screen.dart';
import 'registro_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Préstamos de Libros')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.menu_book_rounded, size: 96, color: color.primary),
            const SizedBox(height: 16),
            Text(
              'Control de préstamos',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Registrar préstamo'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegistroScreen()),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('Ver préstamos'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ListaScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
