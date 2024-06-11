import 'package:cloud_firestore/cloud_firestore.dart';

class Servicios {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCitasStream() {
    return _firestore.collection('Citas').snapshots();
  }

  Future<void> addCita(String note, String centro, String estado, bool importante) {
    return _firestore.collection('Citas').add({
      'note': note,
      'centro': centro,
      'estado': estado,
      'importante': importante,
    });
  }

  Future<void> updateCita(String docID, String note, String centro, String estado, bool importante) {
    return _firestore.collection('Citas').doc(docID).update({
      'note': note,
      'centro': centro,
      'estado': estado,
      'importante': importante,
    });
  }

  Future<void> deleteCita(String docID) {
    return _firestore.collection('Citas').doc(docID).delete();
  }
}
