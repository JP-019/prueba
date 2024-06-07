import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarea/services/firestore.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final Servicios firebaseService = Servicios();
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firebaseService.addNote(textController.text);
              } else {
                firebaseService.updateNote(docID, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text(
              "Add",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notas",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[800],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> notesList = snapshot.data!.docs;
            return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note'];
                  SizedBox(height: 20);
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Color de fondo gris claro
                      borderRadius:
                          BorderRadius.circular(10.0), // Borde redondeado
                    ),
                    child: ListTile(
                      title: Text(noteText),
                      trailing: Container(
                        width:
                            100, // Define el ancho deseado para el IconButton
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => openNoteBox(docID: docID),
                              icon: const Icon(Icons.settings),
                            ),
                            IconButton(
                              onPressed: () =>
                                  firebaseService.deleteNote(docID),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: const Text('No note'),
              ),
            );
          }
        },
      ),
    );
  }
}
