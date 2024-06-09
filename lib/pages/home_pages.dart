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
  String estado = 'creado';
  bool importante = false;

  void openNoteBox(
      {String? docID,
      String? initialText,
      String? initialEstado,
      bool? initialImportante}) {
    textController.text = initialText ?? '';
    setState(() {
      estado = initialEstado ?? 'creado';
      importante = initialImportante ?? false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: 'Escriba'),
                ),
                DropdownButton<String>(
                  value: estado,
                  onChanged: (String? newValue) {
                    setState(() {
                      estado = newValue!;
                    });
                  },
                  items: <String>[
                    'creado',
                    'por hacer',
                    'trabajando',
                    'finalizado'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: importante,
                      onChanged: (bool? newValue) {
                        setState(() {
                          importante = newValue!;
                        });
                      },
                    ),
                    const Text('Importante'),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firebaseService.addNote(
                  textController.text,
                  estado,
                  importante,
                );
              } else {
                firebaseService.updateNote(
                  docID,
                  textController.text,
                  estado,
                  importante,
                );
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
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
        onPressed: () => openNoteBox(),
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
                String estado = data['estado'];
                bool importante = data['importante'];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(noteText),
                    subtitle: Text(
                        'Estado: $estado\nImportante: ${importante ? 'Sí' : 'No'}'),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => openNoteBox(
                              docID: docID,
                              initialText: noteText,
                              initialEstado: estado,
                              initialImportante: importante,
                            ),
                            icon: const Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () => firebaseService.deleteNote(docID),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text('No note'),
              ),
            );
          }
        },
      ),
    );
  }
}
