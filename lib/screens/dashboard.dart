import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meals_app/screens/doctor_schedule.dart';
import 'package:meals_app/screens/line_chart_widget.dart';
import 'package:meals_app/screens/patient_feedback.dart';
import 'package:meals_app/screens/patient_records.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? adminData;

  @override
  void initState() {
    super.initState();
    _getAdminData();
  }

  Future<void> _getAdminData() async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('admin').doc('admin').get();
      if (doc.exists) {
        setState(() {
          adminData = doc.data() as Map<String, dynamic>?;
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error getting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          // Upper part: Admin's profile information
          Container(
            padding: const EdgeInsets.all(25.0),
            color: Colors.blue,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: adminData != null && adminData!['pictureurl'] != null
                      ? NetworkImage(adminData!['pictureurl'])
                      : const AssetImage('assets/placeholder.jpg') as ImageProvider,
                ),
                const SizedBox(height: 8),
                Text(
                  'Name: ${adminData?['Admin Name:'] ?? 'Loading...'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Email: ${adminData?['Admin Email'] ?? 'Loading...'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Phone: ${adminData?['Admin Phone Number'] ?? 'Loading...'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Birthday: ${adminData?['Admin Birthday'] ?? 'Loading...'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Line chart: Applications downloaded over time
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChartWidget(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Default selected index
        onTap: (index) {
          switch (index) {
            case 0:
              // Dashboard
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PatientFeedbackScreen()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PatientRecordsScreen()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DoctorScheduleScreen(doctor: {})),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Patient Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Patient Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Doctor Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Admin Profile',
          ),
        ],
      ),
    );
  }
}
