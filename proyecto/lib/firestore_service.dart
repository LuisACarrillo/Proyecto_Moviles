import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CREATE
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).add(data);
    } catch (e) {
      print('Error al agregar documento: $e');
    }
  }

  // READ ALL
  Future<List<Map<String, dynamic>>> getDocuments(String collection) async {
    try {
      QuerySnapshot snapshot = await _db.collection(collection).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // incluir el id para futuras operaciones
        return data;
      }).toList();
    } catch (e) {
      print('Error al obtener documentos: $e');
      return [];
    }
  }

  // READ ONE
  Future<Map<String, dynamic>?> getDocumentById(String collection, String id) async {
    try {
      DocumentSnapshot doc = await _db.collection(collection).doc(id).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print('Error al obtener documento: $e');
      return null;
    }
  }

  // UPDATE
  Future<void> updateDocument(String collection, String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).doc(id).update(data);
    } catch (e) {
      print('Error al actualizar documento: $e');
    }
  }

  // DELETE
  Future<void> deleteDocument(String collection, String id) async {
    try {
      await _db.collection(collection).doc(id).delete();
    } catch (e) {
      print('Error al eliminar documento: $e');
    }
  }
}
