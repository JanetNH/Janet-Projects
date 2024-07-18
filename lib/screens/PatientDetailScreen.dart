import 'package:flutter/material.dart';

class PatientDetailScreen extends StatefulWidget {
  final String name;
  final String age;
  final String description;
  final String doctor;
  final String appointment;
  final Function(String, String) onUpdate;

  const PatientDetailScreen({
    Key? key,
    required this.name,
    required this.age,
    required this.description,
    required this.doctor,
    required this.appointment,
    required this.onUpdate, required String patientId,
  }) : super(key: key);

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late TextEditingController _doctorController;
  late TextEditingController _appointmentController;

  @override
  void initState() {
    super.initState();
    _doctorController = TextEditingController(text: widget.doctor);
    _appointmentController = TextEditingController(text: widget.appointment);
  }

  @override
  void dispose() {
    _doctorController.dispose();
    _appointmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age: ${widget.age}'),
            Text('Description: ${widget.description}'),
            TextField(
              controller: _doctorController,
              decoration: const InputDecoration(labelText: 'Assigned Doctor'),
            ),
            TextField(
              controller: _appointmentController,
              decoration: const InputDecoration(labelText: 'Appointment Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newDoctor = _doctorController.text;
                final newAppointment = _appointmentController.text;
                widget.onUpdate(newDoctor, newAppointment);
              },
              child: const Text('Update Details'),
            ),
          ],
        ),
      ),
    );
  }
}
