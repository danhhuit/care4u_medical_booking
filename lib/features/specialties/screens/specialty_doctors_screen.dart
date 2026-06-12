import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class SpecialtyDoctorsScreen extends StatefulWidget {
  final int specialtyId;
  final String specialtyName;

  const SpecialtyDoctorsScreen({
    super.key,
    required this.specialtyId,
    required this.specialtyName,
  });

  @override
  State<SpecialtyDoctorsScreen> createState() => _SpecialtyDoctorsScreenState();
}

class _SpecialtyDoctorsScreenState extends State<SpecialtyDoctorsScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _doctors = [];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _api.getDoctorsBySpecialty(widget.specialtyId);

      if (!mounted) return;

      setState(() {
        _doctors = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Không thể tải bác sĩ: $e';
        _isLoading = false;
      });
    }
  }

  String _text(dynamic value) {
    if (value == null || '$value' == 'null') return '';
    return '$value';
  }

  String _doctorName(Map<String, dynamic> doctor) {
    final title = _text(doctor['title']).trim();
    final name = _text(doctor['fullName']).trim();

    if (title.isEmpty) return name.isEmpty ? 'Bác sĩ' : name;
    return '$title ${name.isEmpty ? 'Bác sĩ' : name}';
  }

  Widget _doctorAvatar(Map<String, dynamic> doctor) {
    final imageUrl = _text(
      doctor['avatarUrl'] ?? doctor['avatar_url'] ?? doctor['imageUrl'],
    ).trim();

    if (imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.network(
          imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _avatarPlaceholder(doctor),
        ),
      );
    }

    return _avatarPlaceholder(doctor);
  }

  Widget _avatarPlaceholder(Map<String, dynamic> doctor) {
    final name = _text(doctor['fullName']);
    final first = name.isNotEmpty ? name[0].toUpperCase() : 'B';

    return CircleAvatar(
      radius: 28,
      backgroundColor: const Color(0xFFE8F5F2),
      child: Text(
        first,
        style: const TextStyle(
          color: Color(0xFF2BB5A0),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDoctorInfo(Map<String, dynamic> doctor) {
    final name = _doctorName(doctor);
    final specialty = _text(doctor['specialtyName']).isEmpty
        ? widget.specialtyName
        : _text(doctor['specialtyName']);
    final bio = _text(doctor['bio']).isEmpty
        ? 'Chưa có giới thiệu'
        : _text(doctor['bio']);
    final fee = _text(doctor['consultationFee']).isEmpty
        ? 'Chưa cập nhật'
        : '${doctor['consultationFee']} đ';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(child: _doctorAvatar(doctor)),
              const SizedBox(height: 12),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                specialty,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 16),
              Text(bio, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Text(
                'Phí tư vấn: $fee',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bạn có thể đặt lịch từ màn chi tiết bác sĩ hoặc màn đặt lịch.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Đặt lịch khám'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    final specialtyName = _text(doctor['specialtyName']).isEmpty
        ? widget.specialtyName
        : _text(doctor['specialtyName']);

    final rating = _text(doctor['rating']).isEmpty
        ? '0'
        : _text(doctor['rating']);
    final totalReviews = _text(doctor['totalReviews']).isEmpty
        ? _text(doctor['reviewCount'])
        : _text(doctor['totalReviews']);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: _doctorAvatar(doctor),
        title: Text(
          _doctorName(doctor),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(specialtyName),
              const SizedBox(height: 6),
              Text(
                '⭐ $rating (${totalReviews.isEmpty ? '0' : totalReviews} đánh giá)',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDoctorInfo(doctor),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadDoctors,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_doctors.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadDoctors,
        child: ListView(
          children: const [
            SizedBox(height: 200),
            Center(
              child: Text(
                'Chuyên khoa này chưa có bác sĩ',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDoctors,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          return _buildDoctorCard(_doctors[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text('Bác sĩ ${widget.specialtyName}'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(onPressed: _loadDoctors, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _buildBody(),
    );
  }
}
