import 'package:cloud_firestore/cloud_firestore.dart';

class Mascota {
  final String id;
  final String nombre;
  final String especie;
  final String raza;
  final int edad;
  final DateTime? proximaVacuna;

  final DocumentReference dueno;

  Mascota({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.edad,
    required this.dueno,
    this.proximaVacuna,
  });

  factory Mascota.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Mascota(
      id: snap.id,
      nombre: data['nombre'],
      especie: data['especie'],
      raza: data['raza'],
      edad: data['edad'],
      dueno: data['dueno'],
      proximaVacuna: data['proxima_vacuna'] != null
          ? (data['proxima_vacuna'] as Timestamp).toDate()
          : null,
    );
  }
}
