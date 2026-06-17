import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/features/admin/presentation/screens/admin_user_detail_screen.dart';
import 'package:care4u_medical_booking/features/admin/presentation/widgets/revenue_chart.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/login_phone_screen.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

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
        SnackBar(content: Text('${AppTranslations.tr('cannot_load_accounts')}: $e')),
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
        title: Text(nextActive ? AppTranslations.tr('unlock_account_title') : AppTranslations.tr('lock_account_title')),
        content: Text(
          nextActive
              ? AppTranslations.tr('unlock_account_confirm')
              : AppTranslations.tr('lock_account_confirm'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppTranslations.tr('cancel_label')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppTranslations.tr('agree_label')),
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
          content: Text(AppTranslations.tr('update_status_success')),
          backgroundColor: AppColors.primary,
        ),
      );

      await _loadUsers();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppTranslations.tr('update_status_failed')}: $e')),
      );
    }
  }

  String _roleText(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'doctor':
        return AppTranslations.tr('doctor_label');
      case 'patient':
        return AppTranslations.tr('patient_label');
      default:
        return role;
    }
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'admin':
        return AppColors.primary;
      case 'doctor':
        return AppColors.primary.withValues(alpha: 0.75);
      case 'patient':
        return AppColors.primary.withValues(alpha: 0.55);
      default:
        return AppColors.textLight;
    }
  }

  Widget _buildRoleFilters(Color textColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _roles.map((item) {
          final value = item['value']!;
          final label = item['label']!;
          final selected = _selectedRole == value;

          final displayLabel = value == 'all'
              ? AppTranslations.tr('all_label')
              : value == 'doctor'
              ? AppTranslations.tr('doctor_label')
              : value == 'patient'
              ? AppTranslations.tr('patient_label')
              : label;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                displayLabel,
                style: TextStyle(color: selected ? Colors.white : textColor),
              ),
              selected: selected,
              selectedColor: AppColors.primary,
              backgroundColor: SettingsManager.isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200],
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

  Widget _buildUserCard(Map<String, dynamic> user, Color cardColor, Color textColor, Color subTextColor) {
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
      color: cardColor,
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
                    backgroundColor: _roleColor(role).withValues(alpha: 0.12),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
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
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? AppTranslations.tr('active_status_label') : AppTranslations.tr('locked_status_label'),
                      style: TextStyle(
                        color: isActive ? AppColors.success : AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Email: $email', style: TextStyle(color: subTextColor)),
              if (phone.isNotEmpty && phone != 'null')
                Text('${AppTranslations.tr('phone_label_short')}: $phone', style: TextStyle(color: subTextColor)),
              Text('${AppTranslations.tr('role_label')}: ${_roleText(role)}', style: TextStyle(color: subTextColor)),
              if (licenseNumber.isNotEmpty && licenseNumber != 'null')
                Text('${AppTranslations.tr('license_number')}: $licenseNumber', style: TextStyle(color: subTextColor)),
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
                      label: Text(AppTranslations.tr('details_label')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleStatus(user),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isActive ? AppColors.error : AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(isActive ? Icons.lock : Icons.lock_open),
                      label: Text(isActive ? AppTranslations.tr('lock_action') : AppTranslations.tr('unlock_action')),
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
    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAF9);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final subTextColor = isDark ? Colors.white70 : AppColors.textLight;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(AppTranslations.tr('admin_manage_accounts')),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await SettingsManager.toggleTheme(!isDark);
              setState(() {});
            },
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(onPressed: _loadUsers, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: cardColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: AppTranslations.tr('admin_search_hint'),
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: _loadUsers,
                      icon: const Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  ),
                  onSubmitted: (_) => _loadUsers(),
                ),
                const SizedBox(height: 12),
                _buildRoleFilters(textColor),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                ? Center(child: Text(AppTranslations.tr('no_users_yet'), style: TextStyle(color: textColor)))
                : RefreshIndicator(
                    onRefresh: _loadUsers,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _users.length,
                      itemBuilder: (_, index) {
                        return _buildUserCard(_users[index], cardColor, textColor, subTextColor);
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people, color: AppColors.primary),
            label: AppTranslations.tr('admin_manage_accounts'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart, color: AppColors.primary),
            label: AppTranslations.tr('admin_revenue_stats'),
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
  List<Map<String, dynamic>> _yearlyStats = [];
  RevenuePeriod _period = RevenuePeriod.day;

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
        _error = '${AppTranslations.tr('cannot_load_revenue_stats')}: $e';
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
    final Map<String, Map<String, dynamic>> yearlyMap = {};

    void addToMaps(String dateStr, double amount, String type) {
      if (dateStr.length < 4) return;
      final dayKey = dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;
      final monthKey = dateStr.length >= 7 ? dateStr.substring(0, 7) : dateStr;
      final yearKey = dateStr.substring(0, 4);

      void updateMap(Map<String, Map<String, dynamic>> map, String key) {
        if (!map.containsKey(key)) {
          map[key] = {'date': key, 'booking': 0.0, 'store': 0.0, 'total': 0.0};
        }
        map[key]![type] = (map[key]![type] as double) + amount;
        map[key]!['total'] = (map[key]!['total'] as double) + amount;
      }

      if (dateStr.length >= 10) updateMap(dailyMap, dayKey);
      if (dateStr.length >= 7) updateMap(monthlyMap, monthKey);
      updateMap(yearlyMap, yearKey);
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

    final yearlyList = yearlyMap.values.toList();
    yearlyList.sort((x, y) => '${y['date']}'.compareTo('${x['date']}'));
    _yearlyStats = yearlyList;
  }

  String _formatMoney(double amount) {
    final text = amount.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return '${text}đ';
  }

  String _formatDateDisplay(String key) {
    if (key.length == 4) {
      return '${AppTranslations.tr('year_view')} $key';
    }
    if (key.length == 7) {
      final parts = key.split('-');
      return '${AppTranslations.tr('month_view')} ${parts[1]}/${parts[0]}';
    }
    final parts = key.split('-');
    if (parts.length != 3) return key;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  List<Map<String, dynamic>> get _currentStats {
    switch (_period) {
      case RevenuePeriod.day:
        return _dailyStats;
      case RevenuePeriod.month:
        return _monthlyStats;
      case RevenuePeriod.year:
        return _yearlyStats;
    }
  }

  Widget _statsCard(String label, String value, IconData icon, Color cardColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: textColor.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodSelector(Color cardColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _periodChip(AppTranslations.tr('day_view'), RevenuePeriod.day, textColor),
          _periodChip(AppTranslations.tr('month_view'), RevenuePeriod.month, textColor),
          _periodChip(AppTranslations.tr('year_view'), RevenuePeriod.year, textColor),
        ],
      ),
    );
  }

  Widget _periodChip(String label, RevenuePeriod period, Color textColor) {
    final selected = _period == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _period = period),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? Colors.white : textColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAF9);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final subTextColor = isDark ? Colors.white70 : AppColors.textLight;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 56, color: AppColors.error.withValues(alpha: 0.8)),
                const SizedBox(height: 12),
                Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: AppColors.error)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _loadStats, child: Text(AppTranslations.tr('retry'))),
              ],
            ),
          ),
        ),
      );
    }

    final currentStats = _currentStats;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(AppTranslations.tr('admin_revenue_stats')),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await SettingsManager.toggleTheme(!isDark);
              setState(() {});
            },
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(onPressed: _loadStats, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadStats,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                _statsCard(AppTranslations.tr('total_revenue'), _formatMoney(_totalRevenue), Icons.account_balance_wallet_outlined, cardColor, textColor),
                const SizedBox(width: 10),
                _statsCard(AppTranslations.tr('booking_revenue'), _formatMoney(_bookingRevenue), Icons.calendar_today_outlined, cardColor, textColor),
                const SizedBox(width: 10),
                _statsCard(AppTranslations.tr('store_revenue'), _formatMoney(_storeRevenue), Icons.local_pharmacy_outlined, cardColor, textColor),
              ],
            ),
            const SizedBox(height: 20),
            _periodSelector(cardColor, textColor),
            const SizedBox(height: 20),
            RevenueChart(
              stats: currentStats,
              period: _period,
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            const SizedBox(height: 24),
            Text(
              AppTranslations.tr('revenue_details'),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 12),
            if (currentStats.isEmpty)
              Card(
                color: cardColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: subTextColor.withValues(alpha: 0.15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text(AppTranslations.tr('no_revenue_data'), style: TextStyle(color: subTextColor))),
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
                    color: cardColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: subTextColor.withValues(alpha: 0.12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.trending_up, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatDateDisplay('${stat['date']}'),
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppTranslations.tr('booking_short')}: $bookingStr  ·  ${AppTranslations.tr('store_short')}: $storeStr',
                                  style: TextStyle(fontSize: 12, color: subTextColor),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            totalStr,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
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

