// lib/models/historial_mascota.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class HistorialMascota {
  final String id;
  final String titulo;
  final String tipo;        // vacuna, consulta, etc.
  final String notas;
  final DateTime fecha;
  final DocumentReference veterinario;
  final DocumentReference mascota;

  HistorialMascota({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.notas,
    required this.fecha,
    required this.veterinario,
    required this.mascota,
  });

  factory HistorialMascota.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return HistorialMascota(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      tipo: data['tipo'] ?? '',
      notas: data['notas'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      veterinario: data['veterinario'],
      mascota: data['mascota'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'tipo': tipo,
      'notas': notas,
      'fecha': Timestamp.fromDate(fecha),
      'veterinario': veterinario,
      'mascota': mascota,
    };
  }
}
