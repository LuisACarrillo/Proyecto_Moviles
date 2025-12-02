import 'package:cloud_firestore/cloud_firestore.dart';

class ProductosService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> obtenerProductos() {
    return _db.collection("productos").snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = d.data();
        return {
          "id": d.id,
          "nombre": data["Producto"] ?? "Sin nombre",
          "precio": (data["Precio"] ?? 0).toDouble(),
        };
      }).toList();
    });
  }
}
