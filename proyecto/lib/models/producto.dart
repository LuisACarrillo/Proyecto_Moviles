import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final String imagen;
  final double precio;
  final double rating;
  final int stock;
  final bool activo;

  final DocumentReference? veterinaria;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.imagen,
    required this.precio,
    required this.rating,
    required this.stock,
    required this.activo,
    this.veterinaria,
  });

  factory Producto.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Producto(
      id: snap.id,
      nombre: data['nombre'],
      descripcion: data['descripcion'],
      categoria: data['categoria'],
      imagen: data['imagen'],
      precio: (data['precio']).toDouble(),
      rating: (data['rating']).toDouble(),
      stock: data['stock'],
      activo: data['activo'],
      veterinaria: data['veterinaria'],
    );
  }
}
