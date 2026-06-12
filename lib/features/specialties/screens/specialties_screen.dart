import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/features/specialties/screens/specialty_doctors_screen.dart';

class SpecialtiesScreen extends StatefulWidget {
  const SpecialtiesScreen({super.key});

  @override
  State<SpecialtiesScreen> createState() => _SpecialtiesScreenState();
}

class _SpecialtiesScreenState extends State<SpecialtiesScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _specialties = [];

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _api.getSpecialties();

      if (!mounted) return;

      setState(() {
        _specialties = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Không thể tải chuyên khoa: $e';
        _isLoading = false;
      });
    }
  }

  String _text(dynamic value) {
    if (value == null || '$value' == 'null') return '';
    return '$value';
  }

  IconData _iconForSpecialty(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('tim')) return Icons.favorite;
    if (lower.contains('nhi')) return Icons.child_care;
    if (lower.contains('da')) return Icons.face;
    if (lower.contains('mắt') || lower.contains('mat')) {
      return Icons.visibility;
    }
    if (lower.contains('tai') ||
        lower.contains('mũi') ||
        lower.contains('họng')) {
      return Icons.hearing;
    }
    if (lower.contains('nha')) return Icons.health_and_safety;
    if (lower.contains('tiêu')) return Icons.restaurant;
    if (lower.contains('thần')) return Icons.psychology;

    return Icons.local_hospital;
  }

  Color _colorForIndex(int index) {
    final colors = [
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.blue,
      Colors.green,
      Colors.brown,
    ];

    return colors[index % colors.length];
  }

  Widget _buildSpecialtyCard(Map<String, dynamic> specialty, int index) {
    final id = int.tryParse('${specialty['id'] ?? ''}') ?? 0;
    final name = _text(specialty['name']).isEmpty
        ? 'Chuyên khoa'
        : _text(specialty['name']);

    final color = _colorForIndex(index);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (id <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy mã chuyên khoa')),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SpecialtyDoctorsScreen(specialtyId: id, specialtyName: name),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(_iconForSpecialty(name), color: color, size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
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
                onPressed: _loadSpecialties,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_specialties.isEmpty) {
      return const Center(child: Text('Chưa có chuyên khoa'));
    }

    return RefreshIndicator(
      onRefresh: _loadSpecialties,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _specialties.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          return _buildSpecialtyCard(_specialties[index], index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Chuyên khoa'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadSpecialties,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Tìm bác sĩ theo chuyên khoa',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
