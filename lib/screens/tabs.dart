// lib/screens/tabs_screen.dart

import 'package:flutter/material.dart';
import 'package:meals_app/screens/dashboard.dart'; // Updated import
import 'package:meals_app/screens/patient_feedback.dart';
import 'package:meals_app/screens/patient_records.dart';
import 'package:meals_app/screens/doctor_schedule.dart';


class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const DashboardScreen(); // Updated to DashboardScreen


    switch (_selectedPageIndex) {
      case 0:
        activePage = const PatientFeedbackScreen();
        
        break;
      case 1:
        activePage = const PatientRecordsScreen();
        
        break;
      case 2:
        activePage = const DashboardScreen();
        
        break;
      case 3:
        activePage = const DoctorScheduleScreen(doctor: {},);
        
        break;


    }

    return Scaffold(
      appBar: AppBar(
  
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        selectedItemColor: Colors.white, // Color of selected icon
        unselectedItemColor: Colors.white70, // Color of unselected icons
        backgroundColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}
