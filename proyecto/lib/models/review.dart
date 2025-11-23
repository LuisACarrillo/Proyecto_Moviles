import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final double calificacion;
  final String texto;
  final DocumentReference usuario;
  final DocumentReference doctor;
  final DocumentReference mascota;

  Review({
    required this.id,
    required this.calificacion,
    required this.texto,
    required this.usuario,
    required this.doctor,
    required this.mascota,
  });

  factory Review.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Review(
      id: snap.id,
      calificacion: (data['calificacion']).toDouble(),
      texto: data['texto'],
      usuario: data['usuario'],
      doctor: data['doctor'],
      mascota: data['mascota'],
    );
  }
}
