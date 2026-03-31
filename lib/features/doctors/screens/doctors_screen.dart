import 'package:flutter/material.dart';
import '../widgets/doctor_card.dart';
import 'doctor_detail_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});
  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}
class _DoctorsScreenState extends State<DoctorsScreen> {
  final List<Map<String, dynamic>> _allDoctors = [
    {
      'id': '1',
      'name': 'BS. Nguyễn Văn An',
      'specialty': 'Tim mạch',
      'imageUrl': 'assests/images/bacsi_1.jpg', 
      'rating': 4.8,
      'reviews': 120,
      'bio': 'Bác sĩ An có hơn 10 năm kinh nghiệm trong lĩnh vực Tim mạch, từng tu nghiệp tại Pháp.',
    },
    {
      'id': '2',
      'name': 'BS. Trần Thị Bình',
      'specialty': 'Nhi khoa',
      'imageUrl': 'assests/images/bacsi_2.jpg', 
      'rating': 4.9,
      'reviews': 85,
      'bio': 'Bác sĩ Bình chuyên khoa Nhi, luôn tận tâm và yêu thương trẻ nhỏ.',
    },
    {
      'id': '3',
      'name': 'BS. Lê Trọng Chung',
      'specialty': 'Thần kinh',
      'imageUrl': 'assests/images/bacsi_3.jpg',
      'rating': 4.7,
      'reviews': 50,
      'bio': 'Chuyên gia hàng đầu về các bệnh lý thần kinh và phẫu thuật thần kinh.',
    },
    {
      'id': '4',
      'name': 'BS. Phạm Thị Dung',
      'specialty': 'Da liễu',
      'imageUrl': 'assests/images/bacsi_4.jpg',
      'rating': 4.6,
      'reviews': 200,
      'bio': 'Bác sĩ Dung có kinh nghiệm phong phú trong điều trị các bệnh về da học và thẩm mỹ.',
    },
  ];
  List<Map<String, dynamic>> _filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _filteredDoctors = _allDoctors;
    _searchController.addListener(_filterDoctors);
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _allDoctors.where((doc) {
        final name = doc['name'].toString().toLowerCase();
        final specialty = doc['specialty'].toString().toLowerCase();
        return name.contains(query) || specialty.contains(query);
      }).toList();
    });
  }
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lọc bác sĩ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Chuyên khoa'),
              Wrap(
                spacing: 8,
                children: ['Tim mạch', 'Nhi khoa', 'Thần kinh', 'Da liễu'].map((spec) {
                  return ChoiceChip(
                    label: Text(spec),
                    selected: false,
                    onSelected: (val) {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Áp dụng'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bác sĩ'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm bác sĩ, chuyên khoa...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: _showFilterBottomSheet,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _filteredDoctors.isEmpty
                ? const Center(child: Text('Không tìm thấy bác sĩ nào.'))
                : ListView.builder(
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doc = _filteredDoctors[index];
                      return DoctorCard(
                        name: doc['name'],
                        specialty: doc['specialty'],
                        imageUrl: doc['imageUrl'],
                        rating: (doc['rating'] as num).toDouble(),
                        reviews: doc['reviews'],
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
          ),
        ],
      ),
    );
  }
}