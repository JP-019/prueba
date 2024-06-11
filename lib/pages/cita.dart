import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:tarea/services/firestore.dart';

class CitaPage extends StatefulWidget {
  final String? docID;
  final String? initialNote;
  final String? initialCentro;
  final String? initialEstado;
  final bool? initialImportante;

  const CitaPage({
    Key? key,
    this.docID,
    this.initialNote,
    this.initialCentro,
    this.initialEstado,
    this.initialImportante,
  }) : super(key: key);

  @override
  State<CitaPage> createState() => _CitaPageState();
}

class _CitaPageState extends State<CitaPage> {
  final Servicios firebaseService = Servicios();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController centroController = TextEditingController();
  String estado = 'creado';
  bool importante = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialNote != null) {
      noteController.text = widget.initialNote!;
    }
    if (widget.initialCentro != null) {
      centroController.text = widget.initialCentro!;
    }
    if (widget.initialEstado != null) {
      estado = widget.initialEstado!;
    }
    if (widget.initialImportante != null) {
      importante = widget.initialImportante!;
    }
  }

  void save(BuildContext context) {
    if (widget.docID == null) {
      firebaseService.addCita(
        noteController.text,
        centroController.text,
        estado,
        importante,
      );
    } else {
      firebaseService.updateCita(
        widget.docID!,
        noteController.text,
        centroController.text,
        estado,
        importante,
      );
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asignar Cita"),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => save(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Seleccione un centro médico"),
            DropdownButtonFormField<String>(
              value: centroController.text.isNotEmpty ? centroController.text : null,
              onChanged: (String? newValue) {
                setState(() {
                  centroController.text = newValue!;
                });
              },
              items: <String>[
                'Clinica Norte',
                'Clinica Sur',
                'Clinica Occidente',
                'Clinica Oriente'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                hintText: 'Seleccione un centro médico',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text("Fecha"),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(hintText: 'Escriba la fecha'),
            ),
            const SizedBox(height: 16.0),
            const Text("Jornada"),
            DropdownButtonFormField<String>(
              value: estado.isNotEmpty ? estado : null,
              onChanged: (String? newValue) {
                setState(() {
                  estado = newValue!;
                });
              },
              items: <String>['creado', 'por hacer', 'trabajando', 'finalizado']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                hintText: 'Seleccione la jornada',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text("Reservar un doctor para tu cita"),
            CheckboxListTile(
              value: importante,
              onChanged: (bool? newValue) {
                setState(() {
                  importante = newValue!;
                });
              },
              title: const Text('Importante'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Agrega lógica para buscar doctor
              },
              child: const Text('Buscar doctor'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
