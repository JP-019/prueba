import 'package:cloud_firestore/cloud_firestore.dart';

class Servicios {
  //---------------- get ------------------
  final CollectionReference notas =
      FirebaseFirestore.instance.collection('Nota');

  //---------------- create ----------------
  Future<void> addNote(String note, String estado, bool importante) {
    return notas.add({
      'note': note,
      'estado': estado,
      'importante': importante,
      'timestamp': Timestamp.now(),
    });
  }

  //---------------- read ------------------
  Stream<QuerySnapshot> getNotesStream() {
    return notas.orderBy('timestamp', descending: true).snapshots();
  }

  //---------------- update ----------------
  Future<void> updateNote(String docID, String newNote, String estado, bool importante) {
    return notas.doc(docID).update({
      'note': newNote,
      'estado': estado,
      'importante': importante,
      'timestamp': Timestamp.now(),
    });
  }

  //---------------- delete-----------------
  Future<void> deleteNote(String docID) {
    return notas.doc(docID).delete();
  }
}
