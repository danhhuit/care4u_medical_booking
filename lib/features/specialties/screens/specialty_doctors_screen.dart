import 'package:flutter/material.dart';
import '../../doctors/widgets/doctor_card.dart';
import '../../doctors/screens/doctor_detail_screen.dart';

class SpecialtyDoctorsScreen extends StatelessWidget {
  final String specialty;
  SpecialtyDoctorsScreen({super.key, required this.specialty});
  final List<Map<String, dynamic>> _mockDoctors = [
    {
      'id': 's1',
      'name': 'BS. Nguyễn Văn A',
      'imageUrl': 'assets/images/123.jpg', 
      'rating': 4.8,
      'reviews': 120,
      'bio': 'Bác sĩ có nhiều năm kinh nghiệm trong ngành.',
    },
    {
      'id': 's2',
      'name': 'BS. Trần Thị B',
      'imageUrl': 'assets/images/234.jpg',
      'rating': 4.5,
      'reviews': 95,
      'bio': 'Chuyên gia uy tín, tận tâm với bệnh nhân.',
    },
  ];
  @override
  Widget build(BuildContext context) {
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
                  name: doc['name'] as String,
                  specialty: doc['specialty'] as String,
                  imageUrl: doc['imageUrl'] as String,
                  rating: (doc['rating'] as num).toDouble(),
                  reviews: doc['reviews'] as int,
                  onTap: () {
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