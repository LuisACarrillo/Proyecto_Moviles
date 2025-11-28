import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/models/cita.dart';

class CitasService {
  final _db = FirebaseFirestore.instance;
  final _col = 'citas';

  Future<String> crearCita(Cita cita) async {
    final ref = await _db.collection(_col).add(cita.toMap());
    return ref.id;
  }

  Stream<List<Cita>> obtenerCitasUsuario(String uid) {
    return _db
        .collection(_col)
        .where("usuario", isEqualTo: _db.collection("usuarios").doc(uid))
        .orderBy("fecha", descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((e) => Cita.fromSnapshot(e)).toList());
  }

  Future<void> cancelarCita(String citaId) async {
    await _db.collection(_col).doc(citaId).update({"estado": "cancelada"});
  }

  Future<void> completarCita(String citaId) async {
    await _db.collection(_col).doc(citaId).update({"estado": "completada"});
  }

  Future<void> reprogramarCita(String citaId, DateTime nuevaFecha) async {
    await _db.collection(_col).doc(citaId).update({"fecha": nuevaFecha});
  }

  Future<bool> verificarDisponibilidad({
    required String tipo,
    required DateTime fecha,
    DocumentReference? doctor,
    DocumentReference? paseador,
    DocumentReference? veterinaria,
  }) async {
    final inicio = fecha;
    final fin = fecha.add(const Duration(minutes: 30));

    Query query = _db.collection(_col);

    if (tipo == "Veterinario" && doctor != null) {
      query = query.where("doctor", isEqualTo: doctor);
    }

    if (tipo == "Grooming" && veterinaria != null) {
      query = query.where("veterinaria", isEqualTo: veterinaria);
    }

    if (tipo == "Paseo" && paseador != null) {
      query = query.where("paseador", isEqualTo: paseador);
    }

    final snapshot = await query.get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final citaInicio = (data["fecha"] as Timestamp).toDate();
      final citaFin = citaInicio.add(const Duration(minutes: 30));

      final hayEmpalme = inicio.isBefore(citaFin) && fin.isAfter(citaInicio);

      if (hayEmpalme) return false;
    }

    return true;
  }

  Future<List<DateTime>> obtenerHorariosOcupados({
    required String tipo,
    required DateTime dia,
    DocumentReference? doctor,
    DocumentReference? paseador,
    DocumentReference? veterinaria,
    required DocumentReference usuarioRef,
  }) async {
    final inicioDia = DateTime(dia.year, dia.month, dia.day, 0, 0);
    final finDia = inicioDia.add(const Duration(days: 1));

    Query q = _db
        .collection(_col)
        .where("fecha", isGreaterThanOrEqualTo: inicioDia)
        .where("fecha", isLessThan: finDia);

    if (tipo == "Veterinario" && doctor != null) {
      q = q.where("doctor", isEqualTo: doctor);
    }
    if (tipo == "Paseo" && paseador != null) {
      q = q.where("paseador", isEqualTo: paseador);
    }
    if (tipo == "Grooming" && veterinaria != null) {
      q = q.where("veterinaria", isEqualTo: veterinaria);
    }

    final snap = await q.get();
    List<DateTime> ocupados = [];

    for (var doc in snap.docs) {
      final data = doc.data() as Map<String, dynamic>;
      ocupados.add((data["fecha"] as Timestamp).toDate());
    }

    final userSnap = await _db
        .collection(_col)
        .where("usuario", isEqualTo: usuarioRef)
        .get();

    for (var doc in userSnap.docs) {
      final data = doc.data() as Map<String, dynamic>;
      ocupados.add((data["fecha"] as Timestamp).toDate());
    }

    return ocupados;
  }

  List<DateTime> generarSlotsDisponibles(
    DateTime dia,
    List<DateTime> ocupados,
  ) {
    final List<DateTime> slots = [];

    for (int h = 9; h < 18; h++) {
      for (int m = 0; m < 60; m += 30) {
        final slot = DateTime(dia.year, dia.month, dia.day, h, m);
        final empalmado = ocupados.any((cita) {
          final fin = cita.add(const Duration(minutes: 30));
          return slot.isAfter(cita.subtract(const Duration(minutes: 1))) &&
              slot.isBefore(fin);
        });

        if (!empalmado) slots.add(slot);
      }
    }

    return slots;
  }
}
