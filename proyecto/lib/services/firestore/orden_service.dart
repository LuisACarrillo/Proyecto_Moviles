// lib/services/firestore/orden_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/models/orden.dart';

class OrdenService {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _col => _db.collection('orden');

  Future<String> crearOrden(Orden orden) async {
    final ref = await _col.add(orden.toMap());
    return ref.id;
  }

  Future<List<Orden>> obtenerOrdenesDeUsuario(DocumentReference usuarioRef) async {
    final snap = await _col.where('usuario', isEqualTo: usuarioRef).get();
    return snap.docs.map((d) => Orden.fromSnapshot(d)).toList();
  }

  Future<Orden?> obtenerOrdenPorId(String id) async {
    final snap = await _col.doc(id).get();
    if (snap.exists) {
      return Orden.fromSnapshot(snap);
    }
    return null;
  }

  Future<void> actualizarEstatusOrden(String id, String nuevoEstatus) async {
    await _col.doc(id).update({'estatus': nuevoEstatus});
  }

  Future<void> eliminarOrden(String id) async {
    await _col.doc(id).delete();
  }
}
  