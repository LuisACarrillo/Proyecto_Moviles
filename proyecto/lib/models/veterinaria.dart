import 'package:cloud_firestore/cloud_firestore.dart';

class Veterinaria {
  final String id;
  final String nombre;
  final String direccion;
  final String horaApertura;
  final String horaCierre;   

  final String? telefono;
  final GeoPoint? ubicacion;

  Veterinaria({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.horaApertura,
    required this.horaCierre,
    this.telefono,
    this.ubicacion,
  });

  factory Veterinaria.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return Veterinaria(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      horaApertura: data['hora_apertura'] ?? '',
      horaCierre: data['hora_cierre'] ?? '',
      telefono: data['telefono'],
      ubicacion: data['ubicacion'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'direccion': direccion,
      'hora_apertura': horaApertura,
      'hora_cierre': horaCierre,
      if (telefono != null) 'telefono': telefono,
      if (ubicacion != null) 'ubicacion': ubicacion,
    };
  }
}
