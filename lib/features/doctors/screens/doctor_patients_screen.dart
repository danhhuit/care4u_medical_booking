import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});
  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  final _searchCtrl = TextEditingController();
  late List<Map<String, dynamic>> _filtered;

  // Build a patient list from appointments
  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'p1', 'name': 'Nguyễn Văn Hùng', 'age': 35, 'gender': 'Nam',
      'lastVisit': '2026-03-28', 'diagnosis': 'Hở van tim',
    },
    {
      'id': 'p2', 'name': 'Lê Thị Mai', 'age': 28, 'gender': 'Nữ',
      'lastVisit': '2026-03-20', 'diagnosis': 'Tăng huyết áp',
    },
    {
      'id': 'p3', 'name': 'Trần Minh Khoa', 'age': 45, 'gender': 'Nam',
      'lastVisit': '2026-02-15', 'diagnosis': 'Nhồi máu cơ tim nhẹ',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_patients);
    _searchCtrl.addListener(_filter);
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _patients.where((p) =>
          p['name'].toString().toLowerCase().contains(q)).toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Bệnh nhân của tôi'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bệnh nhân...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final p = _filtered[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        radius: 24,
                        child: Text(
                          p['name'].toString().split(' ').last.substring(0, 1),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['name']!, style: AppTextStyles.bodyDark),
                            Text(
                              '${p['gender']} • ${p['age']} tuổi',
                              style: AppTextStyles.captionLight,
                            ),
                            Text(
                              'Chẩn đoán: ${p['diagnosis']}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Khám gần nhất',
                              style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(p['lastVisit']!,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
