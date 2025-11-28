import 'package:cloud_firestore/cloud_firestore.dart';

class VeterinariasService {
  final _db = FirebaseFirestore.instance;

  Stream<List<DocumentSnapshot>> obtenerVeterinarias() {
    return _db.collection("veterinarias").snapshots().map(
        (snap) => snap.docs
    );
  }
}
