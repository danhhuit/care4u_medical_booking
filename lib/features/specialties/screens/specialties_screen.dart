import 'package:flutter/material.dart';
import '../widgets/specialty_card.dart';
import 'specialty_doctors_screen.dart';

class SpecialtiesScreen extends StatelessWidget {
  const SpecialtiesScreen({super.key});
  final List<Map<String, dynamic>> _specialties = const [
    {'title': 'Tim mạch', 'icon': Icons.favorite, 'color': Colors.red},
    {'title': 'Thần kinh', 'icon': Icons.psychology, 'color': Colors.purple},
    {'title': 'Nhi khoa', 'icon': Icons.child_care, 'color': Colors.orange},
    {'title': 'Da liễu', 'icon': Icons.face, 'color': Colors.pink},
    {'title': 'Nha khoa', 'icon': Icons.health_and_safety, 'color': Colors.teal},
    {'title': 'Mắt', 'icon': Icons.remove_red_eye, 'color': Colors.blue},
    {'title': 'Tai Mũi Họng', 'icon': Icons.hearing, 'color': Colors.green},
    {'title': 'Tiêu hóa', 'icon': Icons.restaurant, 'color': Colors.brown},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuyên khoa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tìm bác sĩ theo chuyên khoa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: _specialties.length,
                itemBuilder: (context, index) {
                  final spec = _specialties[index];
                  return SpecialtyCard(
                    title: spec['title'] as String,
                    icon: spec['icon'] as IconData,
                    color: spec['color'] as Color,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpecialtyDoctorsScreen(
                            specialty: spec['title'] as String,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}