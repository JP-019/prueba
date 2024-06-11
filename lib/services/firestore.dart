import 'package:cloud_firestore/cloud_firestore.dart';

class Servicios {
  //---------------- get ------------------
  final CollectionReference notas =
      FirebaseFirestore.instance.collection('Citas');

  //---------------- create ----------------
  Future<void> addNote(
    String note,
    String centro,
    String estado,
    bool importante,
  ) {
    return notas.add({
      'note': note,
      'Centro': centro,
      'jornada': estado,
      'fecha': Timestamp.now(),
    });
  }

  //---------------- read ------------------
  Stream<QuerySnapshot> getNotesStream() {
    return notas.orderBy('timestamp', descending: true).snapshots();
  }

  //---------------- update ----------------
  Future<void> updateNote(String docID, String newNote, String centro,
      String estado, bool importante) {
    return notas.doc(docID).update({
      'note': newNote,
      'Centro': centro,
      'estado': estado,
      'timestamp': Timestamp.now(),
    });
  }

  //---------------- delete-----------------
  Future<void> deleteNote(String docID) {
    return notas.doc(docID).delete();
  }
}
