import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản trị hệ thống'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Quản lý người dùng'),
            Tab(text: 'Sao lưu dữ liệu'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _UserManagementTab(),
          _BackupTab(),
        ],
      ),
    );
  }
}

class _UserManagementTab extends StatefulWidget {
  @override
  State<_UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends State<_UserManagementTab> {
  final List<Map<String, dynamic>> _users = [
    {'name': 'Nguyễn Văn A', 'email': 'a@example.com', 'role': 'patient'},
    {'name': 'BS. Trần Thị B', 'email': 'b@example.com', 'role': 'doctor'},
    {'name': 'Admin C', 'email': 'c@example.com', 'role': 'admin'},
  ];

  void _createAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo tài khoản mới'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Tên')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(decoration: InputDecoration(labelText: 'Vai trò')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(onPressed: () {
            // Add user logic
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tài khoản đã được tạo')),
            );
          }, child: const Text('Tạo')),
        ],
      ),
    );
  }

  void _deleteAccount(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tài khoản'),
        content: const Text('Bạn có chắc muốn xóa tài khoản này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(onPressed: () {
            setState(() {
              _users.removeAt(index);
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tài khoản đã được xóa')),
            );
          }, child: const Text('Xóa')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _createAccount,
            icon: const Icon(Icons.add),
            label: const Text('Tạo tài khoản mới'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user['name'][0]),
                    ),
                    title: Text(user['name']),
                    subtitle: Text('${user['email']} - ${user['role']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAccount(index),
                    ),
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

class _BackupTab extends StatelessWidget {
  void _performBackup() {
    // Logic to backup data
    // This could involve calling an API or local storage
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sao lưu dữ liệu', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          const Text('Sao lưu toàn bộ dữ liệu hệ thống để đảm bảo an toàn.'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _performBackup,
            icon: const Icon(Icons.backup),
            label: const Text('Bắt đầu sao lưu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          // Đã xóa chữ const gây lỗi ở đây
          Text('Lịch sử sao lưu:', style: AppTextStyles.bodyBold), 
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Sao lưu ngày 22/04/2026'),
                  subtitle: Text('Thành công - 1.2 GB'),
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Sao lưu ngày 15/04/2026'),
                  subtitle: Text('Thành công - 1.1 GB'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}