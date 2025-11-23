import 'package:cloud_firestore/cloud_firestore.dart';

class Cita {
  final String id;
  final DocumentReference doctor;
  final DocumentReference veterinaria;
  final DocumentReference usuario;
  final DocumentReference mascota;

  final DateTime fecha;
  final String motivo;
  final String estado; // pendiente, completada, cancelada

  Cita({
    required this.id,
    required this.doctor,
    required this.veterinaria,
    required this.usuario,
    required this.mascota,
    required this.fecha,
    required this.motivo,
    required this.estado,
  });

  factory Cita.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Cita(
      id: snap.id,
      doctor: data['doctor'],
      veterinaria: data['veterinaria'],
      usuario: data['usuario'],
      mascota: data['mascota'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      motivo: data['motivo'] ?? "",
      estado: data['estado'] ?? "pendiente",
    );
  }

  Map<String, dynamic> toMap() => {
        "doctor": doctor,
        "veterinaria": veterinaria,
        "usuario": usuario,
        "mascota": mascota,
        "fecha": fecha,
        "motivo": motivo,
        "estado": estado,
      };
}
