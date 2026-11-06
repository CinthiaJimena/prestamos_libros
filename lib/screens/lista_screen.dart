import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/prestamos_service.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  String _fmt(Timestamp? t) {
    if (t == null) return '-';
    final d = t.toDate();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<bool> _confirmar(BuildContext context) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar préstamo'),
        content: const Text('¿Seguro que deseas eliminarlo?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final service = PrestamosService();
    return Scaffold(
      appBar: AppBar(title: const Text('Préstamos')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: service.stream(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Aún no hay préstamos'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final d = doc.data();
              final devuelto = d['devuelto'] == true;
              return Card(
                child: ListTile(
                  leading: Icon(
                    devuelto ? Icons.check_circle : Icons.schedule,
                    color: devuelto ? Colors.green : Colors.orange,
                  ),
                  title: Text(
                    d['libro'] ?? '',
                    style: TextStyle(
                      decoration:
                          devuelto ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    'Prestado a: ${d['prestatario'] ?? ''}\n'
                    '${_fmt(d['fechaPrestamo'])} → ${_fmt(d['fechaDevolucion'])}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: devuelto,
                        onChanged: (v) =>
                            service.marcarDevuelto(doc.id, v ?? false),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          if (await _confirmar(context)) {
                            await service.eliminar(doc.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
