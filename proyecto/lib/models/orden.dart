import 'package:cloud_firestore/cloud_firestore.dart';

class OrdenItem {
  final DocumentReference producto;
  final int cantidad;
  final double precioUnitario;

  OrdenItem({
    required this.producto,
    required this.cantidad,
    required this.precioUnitario,
  });

  Map<String, dynamic> toMap() => {
        "producto": producto,
        "cantidad": cantidad,
        "precio_unitario": precioUnitario,
      };
}

class Orden {
  final String id;
  final DateTime creado;
  final double total;
  final String estatus;
  final String metodoPago;              
  final DocumentReference usuario;
  final List<OrdenItem> items;

  Orden({
    required this.id,
    required this.creado,
    required this.total,
    required this.estatus,
    required this.metodoPago,        
    required this.usuario,
    required this.items,
  });

  factory Orden.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Orden(
      id: snap.id,
      creado: (data['creado'] as Timestamp).toDate(),
      total: (data['total']).toDouble(),
      estatus: data['estatus'] ?? '',
      metodoPago: data['metodo_pago'] ?? '',       
      usuario: data['usuario'],
      items: (data['items'] as List)
          .map((e) => OrdenItem(
                producto: e['producto'],
                cantidad: e['cantidad'],
                precioUnitario:
                    (e['precio_unitario'] as num).toDouble(),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creado': Timestamp.fromDate(creado),
      'total': total,
      'estatus': estatus,
      'metodo_pago': metodoPago,       
      'usuario': usuario,
      'items': items.map((e) => e.toMap()).toList(),
    };
  }
}
