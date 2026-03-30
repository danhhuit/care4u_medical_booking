import 'package:flutter/material.dart';
import 'screens/doctors_screen.dart'; 
import 'screens/appointments_screen.dart';

void main() {
  runApp(const MedicalApp());
}

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical App Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ), // Đã sửa: Chỗ này dùng ) chứ không phải ],
      home: const MainNavigation(), 
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Đã sửa: Xóa const trước các Screen vì chúng chứa dữ liệu động
  final List<Widget> _screens = [
    const DoctorsScreen(),      
    const AppointmentsScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sử dụng IndexedStack để giữ trạng thái các tab khi chuyển đổi
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services),
            label: 'Bác sĩ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Lịch hẹn',
          ),
        ],
      ),
    );
  }
}