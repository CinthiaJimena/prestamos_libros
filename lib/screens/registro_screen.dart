import 'package:flutter/material.dart';

import '../services/prestamos_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _libro = TextEditingController();
  final _autor = TextEditingController();
  final _prestatario = TextEditingController();
  final _telefono = TextEditingController();
  final _fPrestamo = TextEditingController();
  final _fDevolucion = TextEditingController();
  late final _service = PrestamosService();

  DateTime? _prestamo;
  DateTime? _devolucion;
  bool _guardando = false;

  @override
  void dispose() {
    for (final c in [
      _libro,
      _autor,
      _prestatario,
      _telefono,
      _fPrestamo,
      _fDevolucion,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _elegirFecha(bool esPrestamo) async {
    final hoy = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: esPrestamo ? (_prestamo ?? hoy) : (_devolucion ?? hoy),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (fecha == null) return;
    setState(() {
      if (esPrestamo) {
        _prestamo = fecha;
        _fPrestamo.text = _fmt(fecha);
      } else {
        _devolucion = fecha;
        _fDevolucion.text = _fmt(fecha);
      }
    });
  }

  String? _requerido(String? v, String campo) =>
      (v == null || v.trim().isEmpty) ? 'El campo $campo es obligatorio' : null;

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await _service.agregar(
        libro: _libro.text,
        autor: _autor.text,
        prestatario: _prestatario.text,
        telefono: _telefono.text,
        fechaPrestamo: _prestamo!,
        fechaDevolucion: _devolucion!,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préstamo registrado correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar préstamo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _libro,
                decoration: const InputDecoration(
                  labelText: 'Libro *',
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _requerido(v, 'libro'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _autor,
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _prestatario,
                decoration: const InputDecoration(
                  labelText: 'Prestado a *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _requerido(v, 'prestatario'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefono,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (10 dígitos)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return null;
                  return RegExp(r'^\d{10}$').hasMatch(t)
                      ? null
                      : 'Ingresa 10 dígitos';
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fPrestamo,
                readOnly: true,
                onTap: () => _elegirFecha(true),
                decoration: const InputDecoration(
                  labelText: 'Fecha de préstamo *',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _requerido(v, 'fecha de préstamo'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fDevolucion,
                readOnly: true,
                onTap: () => _elegirFecha(false),
                decoration: const InputDecoration(
                  labelText: 'Fecha de devolución *',
                  prefixIcon: Icon(Icons.event_available),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final r = _requerido(v, 'fecha de devolución');
                  if (r != null) return r;
                  if (_prestamo != null &&
                      _devolucion != null &&
                      _devolucion!.isBefore(_prestamo!)) {
                    return 'No puede ser anterior al préstamo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
