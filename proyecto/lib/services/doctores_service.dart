import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/models/doctor.dart';

class DoctoresService {
  final _db = FirebaseFirestore.instance;

  Stream<List<String>> obtenerEspecialidades() {
    return _db.collection("doctores").snapshots().map((snap) {
      final s = snap.docs.map((d) => d['especialidad'] as String).toSet();
      return s.toList();
    });
  }

  Stream<List<Doctor>> obtenerDoctoresPorEspecialidad(String especialidad) {
    return _db
        .collection("doctores")
        .where("especialidad", isEqualTo: especialidad)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Doctor.fromSnapshot(d)).toList());
  }
}
