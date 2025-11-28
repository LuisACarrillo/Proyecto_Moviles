import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/models/mascota.dart';

class MascotasService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Mascota>> obtenerMascotasUsuario(String uid) {
    return _db
        .collection("mascotas")
        .where("dueno", isEqualTo: _db.collection("usuarios").doc(uid))
        .snapshots()
        .map((snap) => snap.docs.map((d) => Mascota.fromSnapshot(d)).toList());
  }
}
