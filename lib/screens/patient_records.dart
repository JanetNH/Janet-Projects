import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PatientDetailScreen.dart';

class PatientRecordsScreen extends StatefulWidget {
  const PatientRecordsScreen({Key? key}) : super(key: key);

  @override
  _PatientRecordsScreenState createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Records'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('patient')
            .doc('Patientrecords')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading patient records'));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('No patient records found'));
          }

          final data = snapshot.data!.data()!;
          final patients = _extractPatients(data);

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (ctx, index) {
              final patient = patients[index];

              final name = patient['Name'] ?? 'Unnamed Patient';
              final age = patient['Age'] ?? 'Unknown';
              final description = patient['Description'] ?? 'No Description';
              final doctor = patient['doctor'] ?? '';
              final appointment = patient['Appointment'] ?? '';

              // Check if doctor or appointment is null or empty, and display appropriately
              final doctorText = doctor.isNotEmpty ? 'Doctor: $doctor' : 'No Doctor Assigned';
              final appointmentText = appointment.isNotEmpty ? 'Appointment: $appointment' : 'No Appointment';

              return ListTile(
                title: Text(name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Age: $age'),
                    Text('Description: $description'),
                    Text(doctorText),
                    Text(appointmentText),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientDetailScreen(
                        name: name,
                        age: age,
                        description: description,
                        doctor: doctor,
                        appointment: appointment,
                        onUpdate: (newDoctor, newAppointment) {
                          _updatepatient(patient['index'], newDoctor, newAppointment);
                        }, patientId: '',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Function to extract patients from Firestore data
  List<Map<String, dynamic>> _extractPatients(Map<String, dynamic> data) {
    List<Map<String, dynamic>> patients = [];

    // Assuming 'Name1', 'Name2', ... keys exist for each patient
    int index = 1;
    while (true) {
      if (data.containsKey('Name$index')) {
        Map<String, dynamic> patient = {
          'Name': data['Name$index'],
          'Age': data['Age$index'],
          'Description': data['Description$index'],
          'doctor': data['doctor$index'],
          'Appointment': data['Appointment$index'],
          'index': index, // Include index for updating purposes
        };
        patients.add(patient);
        index++;
      } else {
        break;
      }
    }

    return patients;
  }

  Future<void> _updatepatient(int index, String newDoctor, String newAppointment) async {
    try {
      await FirebaseFirestore.instance
          .collection('patient')
          .doc('Patientrecords')
          .update({
            'doctor$index': newDoctor,
            'Appointment$index': newAppointment,
          });
    } catch (e) {
      print('Error updating patient: $e');
    }
  }
}
