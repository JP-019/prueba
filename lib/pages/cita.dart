import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController centroController = TextEditingController();
  String estado = 'creado';
  bool importante = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // Set initial date to current date
    selectedDate = DateTime.now();
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
            onPressed: () => _saveAndPop(context),
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
              value: widget.initialCentro,
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
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text(
                selectedDate != null
                    ? 'Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
                    : 'Seleccione una fecha',
              ),
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

  void _selectDate(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2100, 12, 31),
      onChanged: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      currentTime: DateTime.now(),
    );
  }

  void _saveAndPop(BuildContext context) {
    if (widget.docID == null) {
      firebaseService.addNote(
        selectedDate
            .toString(), // Change to whatever format you want to save the date
        centroController.text,
        estado,
        importante,
      );
    } else {
      firebaseService.updateNote(
        widget.docID!,
        selectedDate
            .toString(), // Change to whatever format you want to save the date
        centroController.text,
        estado,
        importante,
      );
    }

    if (Navigator.canPop(context)) {
      context.pop();
    } else {
      Navigator.of(context).pop();
    }
  }
}
