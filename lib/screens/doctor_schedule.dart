import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_detail_screen.dart';
 
class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({Key? key, required Map doctor}) : super(key: key);
 
  @override
  _DoctorScheduleScreenState createState() => _DoctorScheduleScreenState();
}
 
class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Schedule'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .doc('doctorschedule') // Corrected document name
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading doctor schedule'));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('No doctor schedule found'));
          }
 
          final data = snapshot.data!.data()!;
          final doctors = _extractDoctors(data);
 
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (ctx, index) {
              final doctor = doctors[index];
              return ListTile(
                title: Text(doctor['name'] ?? 'Unnamed Doctor'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Assigned Patient: ${doctor['patient'] ?? 'None'}'),
                    Text('Appointment Slots: ${doctor['slots'] ?? 'None'}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailScreen(
                        doctorName: doctor['name'] ?? 'Unnamed Doctor',
                        currentPatient: doctor['patient'] ?? '',
                        currentSlots: doctor['slots'] ?? '',
                        onUpdate: (newPatient, newSlots) {
                          _updateDoctorSchedule(index + 1, newPatient, newSlots);
                        },
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
 
  // Function to extract doctors from Firestore data
  List<Map<String, dynamic>> _extractDoctors(Map<String, dynamic> data) {
    List<Map<String, dynamic>> doctors = [];
 
    for (int i = 1; i <= 3; i++) {
      doctors.add({
        'name': data['Name$i'] ?? 'Unnamed Doctor',
        'patient': data['PatientAssgn$i'] ?? 'None',
        'slots': data['Appointment$i'] ?? 'None',
      });
    }
 
    return doctors;
  }
 
  Future<void> _updateDoctorSchedule(int doctorIndex, String newPatient, String newSlots) async {
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc('doctorschedule')
          .update({
        'PatientAssgn$doctorIndex': newPatient,
        'Appointment$doctorIndex': newSlots,
      });
    } catch (e) {
      print('Error updating doctor schedule: $e');
    }
  }
}