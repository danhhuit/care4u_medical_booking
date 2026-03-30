import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ReExaminationView extends StatefulWidget {
  const ReExaminationView({super.key});

  @override
  State<ReExaminationView> createState() => _ReExaminationViewState();
}

class _ReExaminationViewState extends State<ReExaminationView> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;

  final List<String> _dates = ['Hôm nay', 'Ngày mai', '07/04', '08/04', '09/04'];
  final List<String> _days = ['Th 5', 'Th 6', 'CN', 'Th 2', 'Th 3'];
  final List<String> _times = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
    '13:00', '13:30', '14:00', '14:30', '15:00', '15:30'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Đặt lịch tái khám',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Chọn ngày',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDateSelector(),
                  const SizedBox(height: 24),
                  const Text(
                    'Chọn giờ',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeSelector(),
                  const SizedBox(height: 24),
                  const Text(
                    'Lý do khám',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildReasonTextField(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BS. Nguyễn Văn A',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chuyên khoa Tiêu hóa',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                    SizedBox(width: 4),
                    Text(
                      '4.8',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.cases_rounded, color: AppColors.primary, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '10+ năm kinh nghiệm',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(
          _dates.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDateIndex = index;
                });
              },
              child: Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _selectedDateIndex == index ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedDateIndex == index ? AppColors.primary : const Color(0xFFE5E7EB),
                  ),
                  boxShadow: _selectedDateIndex == index
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      _days[index],
                      style: TextStyle(
                        color: _selectedDateIndex == index ? Colors.white70 : const Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _dates[index],
                      style: TextStyle(
                        color: _selectedDateIndex == index ? Colors.white : const Color(0xFF1F2937),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(
        _times.length,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              _selectedTimeIndex = index;
            });
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 40 - 24) / 3,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: _selectedTimeIndex == index ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedTimeIndex == index ? AppColors.primary : const Color(0xFFE5E7EB),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              _times[index],
              style: TextStyle(
                color: _selectedTimeIndex == index ? Colors.white : const Color(0xFF4B5563),
                fontSize: 15,
                fontWeight: _selectedTimeIndex == index ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReasonTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Nhập lý do tái khám hoặc triệu chứng hiện tại...',
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đặt lịch thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Xác nhận đặt lịch',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
