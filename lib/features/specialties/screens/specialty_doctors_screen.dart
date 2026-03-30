import 'package:flutter/material.dart';
import '../../doctors/widgets/doctor_card.dart';
import '../../doctors/screens/doctor_detail_screen.dart';

class SpecialtyDoctorsScreen extends StatelessWidget {
  final String specialty;

  SpecialtyDoctorsScreen({super.key, required this.specialty});

  // Mock list of doctors for this specialty
  final List<Map<String, dynamic>> _mockDoctors = [
    {
      'id': '1',
      'name': 'BS. Nguyễn Văn A',
      'specialty': 'Tim mạch', // This will dynamically match the specialty
      'imageUrl': 'https://via.placeholder.com/150',
      'rating': 4.8,
      'reviews': 120,
      'bio': 'Bác sĩ có nhiều năm kinh nghiệm.',
    },
    {
      'id': '2',
      'name': 'BS. Trần Thị B',
      'specialty': 'Tim mạch', // This will dynamically match the specialty
      'imageUrl': 'https://via.placeholder.com/150',
      'rating': 4.5,
      'reviews': 95,
      'bio': 'Chuyên gia uy tín, tận tâm.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Dynamically overwriting mock specialty to match the title for presentation
    final doctors = _mockDoctors.map((doc) {
      return {...doc, 'specialty': specialty};
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bác sĩ $specialty'),
        centerTitle: true,
      ),
      body: doctors.isEmpty
          ? const Center(child: Text('Không có bác sĩ nào.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doc = doctors[index];
                return DoctorCard(
                  name: doc['name'],
                  specialty: doc['specialty'],
                  imageUrl: doc['imageUrl'],
                  rating: doc['rating'],
                  reviews: doc['reviews'],
                  onTap: () {
                    // Navigate to doctor details screen reusing existing doctors feature
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetailScreen(doctorData: doc),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
