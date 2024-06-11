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
  final TextEditingController textController = TextEditingController();
  final TextEditingController centroController = TextEditingController();
  String estado = 'creado';
  bool importante = false;

  @override
  void initState() {
    super.initState();
    // Llena los campos con los valores iniciales si están disponibles
    if (widget.initialNote != null) {
      textController.text = widget.initialNote!;
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
    // Verifica si se está creando una nueva cita o actualizando una existente
    if (widget.docID == null) {
      // Agrega una nueva cita a la base de datos
      firebaseService.addNote(
        textController.text,
        centroController.text,
        estado,
        importante,
      );
    } else {
      // Actualiza una cita existente en la base de datos
      firebaseService.updateNote(
        widget.docID!,
        textController.text,
        centroController.text,
        estado,
        importante,
      );
    }
    // Después de guardar la cita, regresa a la pantalla principal
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asignar Cita"),
        backgroundColor: Colors.lightBlue,
        actions: [
          // Botón de guardar
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
            // Dropdown para seleccionar el centro médico
            DropdownButtonFormField<String>(
              value: centroController.text.isNotEmpty
                  ? centroController.text
                  : null,
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
            // Campo de texto para ingresar la fecha de la cita
            TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: 'Escriba la fecha'),
            ),
            const SizedBox(height: 16.0),
            const Text("Jornada"),
            // Dropdown para seleccionar la jornada de la cita
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
            // Checkbox para marcar si la cita es importante
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
            // Botón para buscar doctor
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
