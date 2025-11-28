import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/models/paseador.dart';

class PaseadoresService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Paseador>> obtenerPaseadores() {
    return _db
        .collection("paseador")
        .snapshots()
        .map((snap) => snap.docs.map((d) => Paseador.fromSnapshot(d)).toList());
  }
}
