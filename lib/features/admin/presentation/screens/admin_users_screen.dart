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

  int _currentIndex = 0;
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

  Widget _buildAccountsTab() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? _buildAccountsTab() : const AdminRevenueTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tài khoản',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Doanh thu',
          ),
        ],
      ),
    );
  }
}

class AdminRevenueTab extends StatefulWidget {
  const AdminRevenueTab({super.key});

  @override
  State<AdminRevenueTab> createState() => _AdminRevenueTabState();
}

class _AdminRevenueTabState extends State<AdminRevenueTab> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;

  double _totalRevenue = 0;
  double _bookingRevenue = 0;
  double _storeRevenue = 0;

  List<Map<String, dynamic>> _dailyStats = [];
  List<Map<String, dynamic>> _monthlyStats = [];
  bool _isDailyView = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apptsFuture = _api.getAppointments();
      final ordersFuture = _api.getOrders();

      final results = await Future.wait([apptsFuture, ordersFuture]);
      final appts = results[0];
      final orders = results[1];

      _calculateStats(appts, orders);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải dữ liệu thống kê doanh thu: $e';
        _isLoading = false;
      });
    }
  }

  double _calculateOrderTotal(Map<String, dynamic> order) {
    if (order['totalAmount'] != null) {
      return double.tryParse('${order['totalAmount']}') ?? 0;
    }
    if (order['total'] != null) {
      return double.tryParse('${order['total']}') ?? 0;
    }
    final items = order['items'] as List?;
    if (items == null || items.isEmpty) return 0;
    double sum = 0;
    for (final it in items) {
      final price = double.tryParse('${it['price'] ?? it['productPrice'] ?? 0}') ?? 0;
      final qty = int.tryParse('${it['quantity'] ?? 1}') ?? 1;
      sum += price * qty;
    }
    final shipping = double.tryParse('${order['shippingFee'] ?? 30000}') ?? 30000;
    final discount = double.tryParse('${order['discount'] ?? 0}') ?? 0;
    return sum + shipping - discount;
  }

  void _calculateStats(List<Map<String, dynamic>> appts, List<Map<String, dynamic>> orders) {
    double bookingSum = 0;
    double storeSum = 0;

    final Map<String, Map<String, dynamic>> dailyMap = {};
    final Map<String, Map<String, dynamic>> monthlyMap = {};

    void addToMaps(String dateStr, double amount, String type) {
      if (dateStr.length < 10) return;
      final dayKey = dateStr.substring(0, 10);
      final monthKey = dateStr.substring(0, 7);

      // Daily
      if (!dailyMap.containsKey(dayKey)) {
        dailyMap[dayKey] = {'date': dayKey, 'booking': 0.0, 'store': 0.0, 'total': 0.0};
      }
      dailyMap[dayKey]![type] = (dailyMap[dayKey]![type] as double) + amount;
      dailyMap[dayKey]!['total'] = (dailyMap[dayKey]!['total'] as double) + amount;

      // Monthly
      if (!monthlyMap.containsKey(monthKey)) {
        monthlyMap[monthKey] = {'date': monthKey, 'booking': 0.0, 'store': 0.0, 'total': 0.0};
      }
      monthlyMap[monthKey]![type] = (monthlyMap[monthKey]![type] as double) + amount;
      monthlyMap[monthKey]!['total'] = (monthlyMap[monthKey]!['total'] as double) + amount;
    }

    // Process appointments
    for (final a in appts) {
      final status = '${a['status'] ?? ''}'.toLowerCase().trim();
      if (status == 'cancelled' || status == 'da_huy') continue;

      final fee = double.tryParse('${a['consultationFee'] ?? a['doctorFee'] ?? a['fee'] ?? 300000}') ?? 300000;
      bookingSum += fee;

      final dateRaw = '${a['scheduleDate'] ?? a['appointmentDate'] ?? a['date'] ?? a['createdAt'] ?? ''}';
      addToMaps(dateRaw, fee, 'booking');
    }

    // Process store orders
    for (final o in orders) {
      final status = '${o['status'] ?? ''}'.toLowerCase().trim();
      if (status == 'cancelled' || status == 'da_huy') continue;

      final total = _calculateOrderTotal(o);
      storeSum += total;

      final dateRaw = '${o['createdAt'] ?? o['orderDate'] ?? o['date'] ?? ''}';
      addToMaps(dateRaw, total, 'store');
    }

    _bookingRevenue = bookingSum;
    _storeRevenue = storeSum;
    _totalRevenue = bookingSum + storeSum;

    final dailyList = dailyMap.values.toList();
    dailyList.sort((x, y) => '${y['date']}'.compareTo('${x['date']}'));
    _dailyStats = dailyList;

    final monthlyList = monthlyMap.values.toList();
    monthlyList.sort((x, y) => '${y['date']}'.compareTo('${x['date']}'));
    _monthlyStats = monthlyList;
  }

  String _formatMoney(double amount) {
    final text = amount.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return '${text}đ';
  }

  String _formatDateDisplay(String key) {
    if (key.length == 7) {
      final parts = key.split('-');
      return 'Tháng ${parts[1]}/${parts[0]}';
    }
    final parts = key.split('-');
    if (parts.length != 3) return key;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  Widget _statsCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 56, color: Colors.red),
                const SizedBox(height: 12),
                Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _loadStats, child: const Text('Thử lại')),
              ],
            ),
          ),
        ),
      );
    }

    final currentStats = _isDailyView ? _dailyStats : _monthlyStats;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Thống kê doanh thu'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _loadStats, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                _statsCard('Tổng doanh thu', _formatMoney(_totalRevenue), Icons.monetization_on, Colors.blue),
                const SizedBox(width: 8),
                _statsCard('Khám bệnh', _formatMoney(_bookingRevenue), Icons.calendar_today, Colors.green),
                const SizedBox(width: 8),
                _statsCard('Quầy thuốc', _formatMoney(_storeRevenue), Icons.medication, Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chi tiết doanh thu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ToggleButtons(
                  isSelected: [_isDailyView, !_isDailyView],
                  onPressed: (index) {
                    setState(() {
                      _isDailyView = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  constraints: const BoxConstraints(minHeight: 32, minWidth: 64),
                  selectedColor: Colors.white,
                  fillColor: AppColors.primary,
                  children: const [
                    Text('Ngày', style: TextStyle(fontSize: 12)),
                    Text('Tháng', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (currentStats.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Chưa có dữ liệu doanh thu')),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentStats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final stat = currentStats[index];
                  final totalStr = _formatMoney(stat['total'] as double);
                  final bookingStr = _formatMoney(stat['booking'] as double);
                  final storeStr = _formatMoney(stat['store'] as double);

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.trending_up, color: AppColors.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatDateDisplay('${stat['date']}'),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.circle, size: 8, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text('Khám: $bookingStr', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.circle, size: 8, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text('Thuốc: $storeStr', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            totalStr,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

