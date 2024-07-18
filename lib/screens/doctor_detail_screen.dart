import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String doctorName;
  final String currentPatient;
  final String currentSlots;
  final Function(String, String) onUpdate;

  const DoctorDetailScreen({
    Key? key,
    required this.doctorName,
    required this.currentPatient,
    required this.currentSlots,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  late TextEditingController _patientController;
  late TextEditingController _slotsController;

  @override
  void initState() {
    super.initState();
    _patientController = TextEditingController(text: widget.currentPatient);
    _slotsController = TextEditingController(text: widget.currentSlots);
  }

  @override
  void dispose() {
    _patientController.dispose();
    _slotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctorName),
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
            TextField(
              controller: _patientController,
              decoration: const InputDecoration(labelText: 'Assigned Patient'),
            ),
            TextField(
              controller: _slotsController,
              decoration: const InputDecoration(labelText: 'Appointment Slots'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newPatient = _patientController.text;
                final newSlots = _slotsController.text;
                widget.onUpdate(newPatient, newSlots);
              },
              child: const Text('Update Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
