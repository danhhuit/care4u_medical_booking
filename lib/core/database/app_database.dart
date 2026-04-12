import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String account;
  String password;
  String? name;
  String? dob;
  bool? isMale;
  bool isFirstLogin;

  UserModel({
    required this.account,
    required this.password,
    this.name,
    this.dob,
    this.isMale,
    this.isFirstLogin = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'password': password,
      'name': name,
      'dob': dob,
      'isMale': isMale,
      'isFirstLogin': isFirstLogin,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      account: json['account'],
      password: json['password'],
      name: json['name'],
      dob: json['dob'],
      isMale: json['isMale'],
      isFirstLogin: json['isFirstLogin'] ?? true,
    );
  }
}

class DoctorModel extends UserModel {
  final String doctorId;

  DoctorModel({
    required String account,
    required String password,
    required this.doctorId,
  }) : super(account: account, password: password);
}

class AdminModel extends UserModel {
  AdminModel({required String account, required String password})
      : super(account: account, password: password);
}

class AppDatabase {
  // Singleton pattern
  AppDatabase._privateConstructor();
  static final AppDatabase instance = AppDatabase._privateConstructor();

  // Mock DB lists (in memory)
  // Danh sách người dùng được ghi sẵn (Bạn có thể thêm bớt ở đây để quản lý)
  final List<UserModel> _users = [
    UserModel(
      account: '0987654321', 
      password: '123456', 
      name: 'Khách hàng Test 1', 
      dob: '01/01/1990', 
      isMale: true,
      isFirstLogin: false,
    ),
    UserModel(
      account: '0896480152', 
      password: '123456', 
      name: 'Khách hàng Test 2', 
      dob: '15/05/2000', 
      isMale: false,
      isFirstLogin: false,
    ),
  ];
  
  // Seeded Admin
  final List<AdminModel> _admins = [
    AdminModel(account: '0987654321', password: '123456'),
  ];

  // Seeded Doctor
  final List<DoctorModel> _doctors = [
    DoctorModel(account: '0123456789', password: '123456', doctorId: 'BS001'),
  ];

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadUsersFromPrefs();
  }

  Future<void> _loadUsersFromPrefs() async {
    final String? usersJson = _prefs.getString('users_db');
    if (usersJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(usersJson);
        _users.clear();
        for (var item in decodedList) {
          _users.add(UserModel.fromJson(item));
        }
      } catch (e) {
        // Handle JSON error, maybe ignore
      }
    }
  }

  Future<void> _saveUsersToPrefs() async {
    final List<Map<String, dynamic>> jsonList = _users.map((e) => e.toJson()).toList();
    final String encodedStr = jsonEncode(jsonList);
    await _prefs.setString('users_db', encodedStr);
  }

  // Register a standard user
  Future<bool> registerUser(String account, String password) async {
    // Check if user already exists
    if (_users.any((u) => u.account == account)) {
      return false; // Already exists
    }
    _users.add(UserModel(account: account, password: password));
    await _saveUsersToPrefs();
    return true;
  }

  // Get user by account
  UserModel? getUserByAccount(String account) {
    try {
      return _users.firstWhere((u) => u.account == account);
    } catch (e) {
      return null;
    }
  }

  // Check if account exists (Users or Doctors, ignore Admin for forgot password)
  bool checkAccountExists(String account) {
    bool isUser = _users.any((u) => u.account == account);
    bool isDoctor = _doctors.any((d) => d.account == account);
    return isUser || isDoctor;
  }

  // Check login for User
  Future<bool> loginUser(String account, String password) async {
    return _users.any((u) => u.account == account && u.password == password);
  }

  // Check login for Admin
  Future<bool> loginAdmin(String account, String password) async {
    return _admins.any((a) => a.account == account && a.password == password);
  }

  // Check login for Doctor
  Future<bool> loginDoctor(String account, String password, String doctorId) async {
    return _doctors.any((d) =>
        d.account == account &&
        d.password == password &&
        d.doctorId == doctorId);
  }

  // Update User Profile
  Future<bool> updateUserProfile(String account, String name, String dob, bool isMale) async {
    for (var u in _users) {
      if (u.account == account) {
        u.name = name;
        u.dob = dob;
        u.isMale = isMale;
        u.isFirstLogin = false;
        await _saveUsersToPrefs();
        return true;
      }
    }
    return false;
  }

  // Mark first login as done
  Future<void> markFirstLoginDone(String account) async {
    for (var u in _users) {
      if (u.account == account) {
        if (u.isFirstLogin) {
          u.isFirstLogin = false;
          await _saveUsersToPrefs();
        }
        break;
      }
    }
  }

  // Update password
  Future<bool> updatePassword(String account, String newPassword) async {
    bool updatedUser = false;
    bool updatedOther = false;

    // Check users
    for (var u in _users) {
      if (u.account == account) {
        u.password = newPassword;
        updatedUser = true;
      }
    }

    if (updatedUser) {
      await _saveUsersToPrefs();
    }

    // Check admins
    for (var a in _admins) {
      if (a.account == account) {
        a.password = newPassword;
        updatedOther = true;
      }
    }

    // Check doctors
    for (var d in _doctors) {
      if (d.account == account) {
        d.password = newPassword;
        updatedOther = true;
      }
    }

    return updatedUser || updatedOther;
  }
}
