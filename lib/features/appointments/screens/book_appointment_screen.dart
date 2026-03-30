import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;
  const BookAppointmentScreen({super.key, required this.doctorData});
  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}
class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  final List<String> _dates = ['T2, 12/10', 'T3, 13/10', 'T4, 14/10', 'T5, 15/10', 'T6, 16/10'];
  final List<String> _times = [
    '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
    '13:00 PM', '14:00 PM', '15:00 PM', '16:00 PM'
  ];
  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.doctorData['imageUrl'] ?? 'assests/images/default_doctor.jpg';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lịch hẹn'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(imagePath),
                    onBackgroundImageError: (_, __) {
                      debugPrint('Không tìm thấy ảnh asset: $imagePath');
                    },
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctorData['name'] ?? 'Bác sĩ',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.doctorData['specialty'] ?? 'Chuyên khoa',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Chọn ngày',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedDateIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDateIndex = index),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _dates[index].replaceFirst(', ', '\n'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Chọn giờ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _times.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedTimeIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTimeIndex = index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _times[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _selectedTimeIndex == -1
                ? null 
                : () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thành công'),
                        content: const Text('Bạn đã đặt lịch khám thành công!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); 
                              Navigator.pop(context); 
                            },
                            child: const Text('Đóng'),
                          )
                        ],
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: const Text(
              'Xác nhận đặt lịch',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}