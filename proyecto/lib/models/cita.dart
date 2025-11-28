import 'package:cloud_firestore/cloud_firestore.dart';

class Cita {
  final String id;

  final DocumentReference? doctor;
  final DocumentReference? paseador;

  final DocumentReference? veterinaria;

  final DocumentReference usuario;
  final DocumentReference mascota;

  final DateTime fecha;
  final String motivo;

  // pendiente, completada, cancelada
  final String estado;

  final String tipo; // "veterinario", "paseo", "grooming"

  Cita({
    required this.id,
    required this.usuario,
    required this.mascota,
    required this.fecha,
    required this.motivo,
    required this.estado,
    required this.tipo,
    this.doctor,
    this.paseador,
    this.veterinaria,
  });

  factory Cita.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Cita(
      id: snap.id,
      usuario: data['usuario'],
      mascota: data['mascota'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      motivo: data['motivo'] ?? "",
      estado: data['estado'] ?? "pendiente",
      tipo: data['tipo'] ?? "veterinario",

      doctor: data['doctor'],
      paseador: data['paseador'],
      veterinaria: data['veterinaria'],
    );
  }

  Map<String, dynamic> toMap() => {
    "usuario": usuario,
    "mascota": mascota,
    "fecha": fecha,
    "motivo": motivo,
    "estado": estado,
    "tipo": tipo,

    if (doctor != null) "doctor": doctor,
    if (paseador != null) "paseador": paseador,
    if (veterinaria != null) "veterinaria": veterinaria,
  };
}
