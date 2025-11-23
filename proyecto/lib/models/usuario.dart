import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String email;
  final String phone;
  final String nombre;
  final DateTime creado;

  Usuario({
    required this.id,
    required this.email,
    required this.phone,
    required this.nombre,
    required this.creado,
  });

  factory Usuario.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Usuario(
      id: snap.id,
      email: data['email'],
      phone: data['phone'],
      nombre: data['nombre'],
      creado: (data['creado'] as Timestamp).toDate(),
    );
  }
}
