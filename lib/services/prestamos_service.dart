import 'package:cloud_firestore/cloud_firestore.dart';

class PrestamosService {
  final CollectionReference<Map<String, dynamic>> _col = FirebaseFirestore
      .instance
      .collection('prestamos');

  Future<void> agregar({
    required String libro,
    required String autor,
    required String prestatario,
    required String telefono,
    required DateTime fechaPrestamo,
    required DateTime fechaDevolucion,
  }) {
    return _col.add({
      'libro': libro.trim(),
      'autor': autor.trim(),
      'prestatario': prestatario.trim(),
      'telefono': telefono.trim(),
      'fechaPrestamo': Timestamp.fromDate(fechaPrestamo),
      'fechaDevolucion': Timestamp.fromDate(fechaDevolucion),
      'devuelto': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stream() =>
      _col.orderBy('createdAt', descending: true).snapshots();

  Future<void> marcarDevuelto(String id, bool valor) =>
      _col.doc(id).update({'devuelto': valor});

  Future<void> eliminar(String id) => _col.doc(id).delete();
}
