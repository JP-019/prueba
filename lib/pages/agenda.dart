import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarea/services/firestore.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final Servicios firebaseService = Servicios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getCitasStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay citas'));
          } else {
            print('Citas recuperadas: ${snapshot.data!.docs.length}'); // Debug
            List<DocumentSnapshot> citasList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: citasList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = citasList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                print('Datos de la cita: $data'); // Debug

                String noteText = data['note'] ?? 'Nota sin texto';
                String centro = data['centro'] ?? 'Centro desconocido';
                String estado = data['estado'] ?? 'Desconocido';
                bool importante = data['importante'] ?? false;

                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 171, 166, 166),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(noteText),
                    subtitle: Text(
                        'Centro: $centro\nEstado: $estado\nImportante: ${importante ? 'Sí' : 'No'}'),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => _openCitaPage(
                              docID: docID,
                              initialNote: noteText,
                              initialCentro: centro,
                              initialEstado: estado,
                              initialImportante: importante,
                            ),
                            icon: const Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () => _deleteCita(docID),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go("/cita"),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteCita(String docID) {
    firebaseService.deleteCita(docID);
  }

  void _openCitaPage({
    String? docID,
    String? initialNote,
    String? initialCentro,
    String? initialEstado,
    bool? initialImportante,
  }) {
    context.go(
      '/cita',
      extra: {
        'docID': docID,
        'initialNote': initialNote,
        'initialCentro': initialCentro,
        'initialEstado': initialEstado,
        'initialImportante': initialImportante,
      },
    );
  }
}
