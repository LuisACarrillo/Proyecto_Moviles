import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String nombre;
  final String especialidad;
  final String contacto;
  final DocumentReference ubicacion;

  Doctor({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.contacto,
    required this.ubicacion,
  });

  factory Doctor.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Doctor(
      id: snap.id,
      nombre: data['nombre'],
      especialidad: data['especialidad'],
      contacto: data['contacto'],
      ubicacion: data['ubicacion'],
    );
  }
}
