import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/features/admin/presentation/screens/admin_user_detail_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/login_phone_screen.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final Care4UApiService _api = Care4UApiService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  String _selectedRole = 'all';
  List<Map<String, dynamic>> _users = [];

  final List<Map<String, String>> _roles = const [
    {'value': 'all', 'label': 'Tất cả'},
    {'value': 'admin', 'label': 'Admin'},
    {'value': 'doctor', 'label': 'Bác sĩ'},
    {'value': 'patient', 'label': 'Bệnh nhân'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);

    try {
      final data = await _api.getAdminUsers(
        role: _selectedRole,
        keyword: _searchController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _users = data;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tải danh sách tài khoản thất bại: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleStatus(Map<String, dynamic> user) async {
    final userId = '${user['userId'] ?? ''}';
    final currentActive = user['isActive'] == true;
    final nextActive = !currentActive;

    if (userId.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(nextActive ? 'Mở khóa tài khoản' : 'Khóa tài khoản'),
        content: Text(
          nextActive
              ? 'Bạn có chắc muốn mở khóa tài khoản này?'
              : 'Bạn có chắc muốn khóa tài khoản này? Người dùng sẽ không thể đăng nhập.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _api.updateAdminUserStatus(userId: userId, isActive: nextActive);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nextActive ? 'Đã mở khóa tài khoản' : 'Đã khóa tài khoản',
          ),
        ),
      );

      await _loadUsers();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật trạng thái thất bại: $e')),
      );
    }
  }

  String _roleText(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'doctor':
        return 'Bác sĩ';
      case 'patient':
        return 'Bệnh nhân';
      default:
        return role;
    }
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'doctor':
        return Colors.blue;
      case 'patient':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRoleFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _roles.map((item) {
          final value = item['value']!;
          final label = item['label']!;
          final selected = _selectedRole == value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _selectedRole = value;
                });
                _loadUsers();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final userId = '${user['userId'] ?? ''}';
    final email = '${user['email'] ?? ''}';
    final phone = '${user['phone'] ?? ''}';
    final role = '${user['role'] ?? ''}';
    final fullName = '${user['fullName'] ?? ''}';
    final licenseNumber = '${user['licenseNumber'] ?? ''}';
    final isActive = user['isActive'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      child: InkWell(
        onTap: () async {
          final changed = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AdminUserDetailScreen(userId: userId),
            ),
          );

          if (changed == true) {
            _loadUsers();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _roleColor(role).withOpacity(0.12),
                    child: Icon(
                      role == 'doctor'
                          ? Icons.medical_services
                          : role == 'admin'
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      color: _roleColor(role),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fullName.isNotEmpty ? fullName : email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.12)
                          : Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? 'Đang hoạt động' : 'Đã khóa',
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Email: $email'),
              if (phone.isNotEmpty && phone != 'null') Text('SĐT: $phone'),
              Text('Vai trò: ${_roleText(role)}'),
              if (licenseNumber.isNotEmpty && licenseNumber != 'null')
                Text('Mã định danh: $licenseNumber'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final changed = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AdminUserDetailScreen(userId: userId),
                          ),
                        );

                        if (changed == true) {
                          _loadUsers();
                        }
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('Chi tiết'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleStatus(user),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isActive ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(isActive ? Icons.lock : Icons.lock_open),
                      label: Text(isActive ? 'Khóa' : 'Mở khóa'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPhoneScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Quản lý tài khoản'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _loadUsers, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm email hoặc số điện thoại',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: _loadUsers,
                      icon: const Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _loadUsers(),
                ),
                const SizedBox(height: 12),
                _buildRoleFilters(),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                ? const Center(child: Text('Không có tài khoản nào'))
                : RefreshIndicator(
                    onRefresh: _loadUsers,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _users.length,
                      itemBuilder: (_, index) {
                        return _buildUserCard(_users[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
