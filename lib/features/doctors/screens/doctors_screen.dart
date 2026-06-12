import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import '../widgets/doctor_card.dart';
import 'doctor_detail_screen.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final Care4UApiService _api = Care4UApiService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _allDoctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  List<String> _specialties = [];
  String? _selectedSpecialty; // null = all

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilters);
    _loadDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiDoctors = await _api.getDoctors();
      final normalizedDoctors = apiDoctors.map(_normalizeDoctor).toList();
      final specialtyList = normalizedDoctors
          .map((d) => '${d['specialty'] ?? ''}')
          .where((s) => s.trim().isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      if (!mounted) return;

      setState(() {
        _allDoctors = normalizedDoctors;
        _specialties = specialtyList;
        _isLoading = false;
      });

      _applyFilters();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Không thể tải danh sách bác sĩ: $e';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _normalizeDoctor(Map<String, dynamic> raw) {
    final fullName = '${raw['fullName'] ?? raw['name'] ?? 'Chưa có tên'}';
    final title = '${raw['title'] ?? ''}'.trim();
    final displayName = title.isEmpty ? fullName : '$title $fullName';
    final specialty = '${raw['specialtyName'] ?? raw['specialty'] ?? 'Chưa cập nhật'}';
    final hospital = '${raw['healthCenterName'] ?? raw['hospital'] ?? 'Chưa cập nhật'}';
    final address = '${raw['healthCenterAddress'] ?? raw['address'] ?? ''}';
    final experienceYears = raw['experienceYears'] ?? 0;
    final totalReviews = raw['totalReviews'] ?? raw['reviews'] ?? 0;
    final avatarUrl = raw['avatarUrl'] ?? raw['imageUrl'];

    return {
      ...raw,
      'id': raw['id'],
      'apiId': raw['id'],
      'name': displayName,
      'fullName': fullName,
      'title': title,
      'specialty': specialty,
      'specialtyName': specialty,
      'hospital': hospital,
      'healthCenterName': hospital,
      'address': address,
      'healthCenterAddress': address,
      'imageUrl': avatarUrl ?? 'assests/images/default_doctor.jpg',
      'avatarUrl': avatarUrl,
      'rating': raw['rating'] ?? 0.0,
      'reviews': totalReviews,
      'totalReviews': totalReviews,
      'experience': '$experienceYears năm',
      'experienceYears': experienceYears,
      'consultationFee': raw['consultationFee'],
      'bio': raw['bio'] ?? 'Chưa có thông tin giới thiệu.',
      'isAvailable': raw['isAvailable'] ?? true,
    };
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();

    if (!mounted) return;

    setState(() {
      _filteredDoctors = _allDoctors.where((doc) {
        final name = '${doc['name'] ?? ''}'.toLowerCase();
        final fullName = '${doc['fullName'] ?? ''}'.toLowerCase();
        final specialty = '${doc['specialty'] ?? ''}'.toLowerCase();
        final hospital = '${doc['hospital'] ?? ''}'.toLowerCase();

        final matchesSearch = query.isEmpty ||
            name.contains(query) ||
            fullName.contains(query) ||
            specialty.contains(query) ||
            hospital.contains(query);

        final matchesSpecialty = _selectedSpecialty == null ||
            doc['specialty'] == _selectedSpecialty;

        return matchesSearch && matchesSpecialty;
      }).toList();
    });
  }

  String _getSpecialtyTranslationKey(String spec) {
    if (spec == 'Tim mạch') return 'cardiology';
    if (spec == 'Nhi khoa') return 'pediatrics';
    if (spec == 'Thần kinh') return 'neurology';
    if (spec == 'Da liễu') return 'dermatology';
    return spec;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ValueListenableBuilder<String>(
              valueListenable: SettingsManager.languageCode,
              builder: (context, lang, _) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppTranslations.tr('doctors_list_title'),
                            style: AppTextStyles.heading2,
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {});
                              setState(() {
                                _selectedSpecialty = null;
                              });
                              _applyFilters();
                            },
                            child: Text(
                              AppTranslations.tr('close'),
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppTranslations.tr('specialties'),
                        style: AppTextStyles.captionDark,
                      ),
                      const SizedBox(height: 8),
                      if (_specialties.isEmpty)
                        const Text('Chưa có chuyên khoa')
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _specialties.map((spec) {
                            final isSelected = _selectedSpecialty == spec;
                            return ChoiceChip(
                              label: Text(
                                AppTranslations.tr(
                                  _getSpecialtyTranslationKey(spec),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textDark,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (val) {
                                setModalState(() {
                                  _selectedSpecialty = val ? spec : null;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {});
                            _applyFilters();
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppTranslations.tr('success'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDoctors,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredDoctors.isEmpty) {
      return Center(child: Text(AppTranslations.tr('no_appointments')));
    }

    return RefreshIndicator(
      onRefresh: _loadDoctors,
      child: ListView.builder(
        itemCount: _filteredDoctors.length,
        itemBuilder: (context, index) {
          final doc = _filteredDoctors[index];
          return DoctorCard(
            name: doc['name'] ?? 'Chưa có tên',
            specialty: AppTranslations.tr(
              _getSpecialtyTranslationKey((doc['specialty'] as String?) ?? ''),
            ),
            imageUrl: doc['imageUrl'],
            rating: (doc['rating'] as num?)?.toDouble() ?? 0.0,
            reviews: doc['reviews'] ?? 0,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorDetailScreen(doctorData: doc),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppTranslations.tr('doctors_list_title')),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
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
                          hintText: AppTranslations.tr('search_doctor_hint'),
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
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _selectedSpecialty != null
                                ? AppColors.primary
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            ),
                            onPressed: _showFilterBottomSheet,
                          ),
                        ),
                        if (_selectedSpecialty != null)
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_selectedSpecialty != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Chip(
                        label: Text(
                          AppTranslations.tr(
                            _getSpecialtyTranslationKey(_selectedSpecialty!),
                          ),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() => _selectedSpecialty = null);
                          _applyFilters();
                        },
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: const TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              Expanded(child: _buildList()),
            ],
          ),
        );
      },
    );
  }
}
