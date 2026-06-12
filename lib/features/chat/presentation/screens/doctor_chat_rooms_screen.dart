import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'chat_detail_screen.dart';

class DoctorChatRoomsScreen extends StatefulWidget {
  const DoctorChatRoomsScreen({super.key});

  @override
  State<DoctorChatRoomsScreen> createState() => _DoctorChatRoomsScreenState();
}

class _DoctorChatRoomsScreenState extends State<DoctorChatRoomsScreen> {
  int get currentDoctorId => SettingsManager.currentDoctorId;

  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getChatRoomsByDoctor(currentDoctorId);
      if (!mounted) return;
      setState(() {
        _rooms = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không tìm thấy danh sách tin nhắn: $e';
        _isLoading = false;
      });
    }
  }

  // Future<void> _createTestRoom() async {
  //   try {
  //     await _api.createOrGetChatRoom(patientId: 1, doctorId: currentDoctorId);
  //     await _loadRooms();
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Đã tạo/lấy phòng chat với bệnh nhân 1')),
  //     );
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Tạo phòng chat thất bại: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  String _text(dynamic value, {String fallback = 'Chưa cập nhật'}) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  String _lastMessage(Map<String, dynamic> room) {
    final raw = room['lastMessage'];
    if (raw is Map) {
      final content = '${raw['content'] ?? ''}'.trim();
      if (content.isNotEmpty) return content;
    }
    return 'Chưa có tin nhắn';
  }

  String _formatTime(dynamic value) {
    final raw = '${value ?? ''}';
    if (raw.isEmpty || raw == 'null') return '';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return '';
    final local = dt.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openRoom(Map<String, dynamic> room) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          roomId: '${room['id']}',
          title: _text(room['patientName'], fallback: 'Bệnh nhân'),
          senderRole: 'doctor',
        ),
      ),
    );

    await _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Tin nhắn'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(onPressed: _loadRooms, icon: const Icon(Icons.refresh)),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _createTestRoom,
      //   backgroundColor: AppColors.primary,
      //   icon: const Icon(Icons.add, color: Colors.white),
      //   label: const Text(
      //     'Tạo chat test',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadRooms,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_rooms.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadRooms,
        child: ListView(
          children: const [
            SizedBox(height: 180),
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Center(child: Text('Chưa có phòng chat')),
            SizedBox(height: 8),
            Center(
              child: Text('Bấm "Tạo chat test" để tạo phòng với bệnh nhân 1'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRooms,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _rooms.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final room = _rooms[index];
          final unread = int.tryParse('${room['unreadCount'] ?? 0}') ?? 0;

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              onTap: () => _openRoom(room),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.12),
                child: Text(
                  _text(
                    room['patientName'],
                    fallback: 'B',
                  ).split(' ').last.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                _text(room['patientName'], fallback: 'Bệnh nhân'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _lastMessage(room),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(room['lastMessageAt']),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  if (unread > 0) ...[
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '$unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

