import 'package:cloud_firestore/cloud_firestore.dart';

class Paseador {
  final String id;
  final String nombre;

  Paseador({required this.id, required this.nombre});

  factory Paseador.fromSnapshot(DocumentSnapshot snap) {
    final d = snap.data() as Map<String, dynamic>;
    return Paseador(id: snap.id, nombre: d['Nombre']);
  }
}
