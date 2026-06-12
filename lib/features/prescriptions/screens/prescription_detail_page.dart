import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class PrescriptionDetailScreen extends StatefulWidget {
  final int prescriptionId;
  final Map<String, dynamic>? initialData;

  const PrescriptionDetailScreen({
    super.key,
    required this.prescriptionId,
    this.initialData,
  });

  @override
  State<PrescriptionDetailScreen> createState() =>
      _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _prescription;

  @override
  void initState() {
    super.initState();
    _prescription = widget.initialData;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = _prescription == null;
      _error = null;
    });

    try {
      final data = await _api.getObject(
        '/Prescriptions/${widget.prescriptionId}',
      );
      if (!mounted) return;
      setState(() {
        _prescription = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải chi tiết đơn thuốc: $e';
        _isLoading = false;
      });
    }
  }

  String _text(dynamic value, {String fallback = 'Chưa cập nhật'}) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  String _formatDate(dynamic value) {
    final raw = _text(value, fallback: '');
    if (raw.isEmpty) return 'Chưa cập nhật';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final data = _prescription;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Chi tiết đơn thuốc'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(onPressed: _loadDetail, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _buildBody(data),
    );
  }

  Widget _buildBody(Map<String, dynamic>? data) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadDetail,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (data == null) {
      return const Center(child: Text('Không có dữ liệu đơn thuốc'));
    }

    final items = (data['items'] as List?) ?? [];

    return RefreshIndicator(
      onRefresh: _loadDetail,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _headerCard(data),
          const SizedBox(height: 16),
          const Text(
            'Danh sách thuốc',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            _emptyMedicineCard()
          else
            ...items.map((raw) {
              final med = Map<String, dynamic>.from(raw as Map);
              return _medicineCard(med);
            }),
          const SizedBox(height: 16),
          _noteCard(data),
        ],
      ),
    );
  }

  Widget _headerCard(Map<String, dynamic> data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.receipt_long, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _text(data['prescriptionNo'], fallback: 'Đơn thuốc'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text('Trạng thái: ${_text(data['status'])}'),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _infoRow('Ngày kê', _formatDate(data['dateIssued'])),
            _infoRow('Có hiệu lực đến', _formatDate(data['validUntil'])),
            _infoRow('Bệnh nhân', _text(data['patientName'])),
            _infoRow(
              'Bác sĩ',
              '${_text(data['doctorTitle'], fallback: '')} ${_text(data['doctorName'])}'
                  .trim(),
            ),
            _infoRow('Mã hồ sơ bệnh án', _text(data['medicalRecordId'])),
          ],
        ),
      ),
    );
  }

  Widget _medicineCard(Map<String, dynamic> med) {
    final medicineName = _text(med['medicineName'], fallback: 'Tên thuốc');
    final strength = _text(med['strength'], fallback: '');
    final dosageForm = _text(med['dosageForm'], fallback: '');

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medication, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicineName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (strength.isNotEmpty || dosageForm.isNotEmpty)
                        Text(
                          '$strength $dosageForm'.trim(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow('Liều dùng', _text(med['dosage'])),
            _infoRow('Tần suất', _text(med['frequency'])),
            _infoRow('Thời gian dùng', _text(med['duration'])),
            _infoRow('Số lượng', _text(med['quantity'])),
            _infoRow('Hướng dẫn', _text(med['instructions'])),
          ],
        ),
      ),
    );
  }

  Widget _noteCard(Map<String, dynamic> data) {
    final notes = _text(data['notes']);
    final pharmacistNotes = _text(data['pharmacistNotes']);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Ghi chú',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _infoRow('Bác sĩ ghi chú', notes),
            _infoRow('Dược sĩ ghi chú', pharmacistNotes),
          ],
        ),
      ),
    );
  }

  Widget _emptyMedicineCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            'Chưa có thuốc trong đơn',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
