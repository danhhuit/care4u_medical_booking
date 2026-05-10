import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserModel {
  final String account;
  String password;
  String? name;
  String? dob;
  bool? isMale;
  bool isFirstLogin;
  String? email;
  String? address;
  String? bloodType;
  String? avatar;

  UserModel({
    required this.account,
    required this.password,
    this.name,
    this.dob,
    this.isMale,
    this.isFirstLogin = true,
    this.email,
    this.address,
    this.bloodType,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'password': password,
      'name': name,
      'dob': dob,
      'isMale': isMale,
      'isFirstLogin': isFirstLogin,
      'email': email,
      'address': address,
      'bloodType': bloodType,
      'avatar': avatar,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      account: json['account'],
      password: json['password'],
      name: json['name'],
      dob: json['dob'],
      isMale: json['isMale'] is bool ? json['isMale'] : (json['isMale'] == 1),
      isFirstLogin: json['isFirstLogin'] is bool 
          ? json['isFirstLogin'] 
          : (json['isFirstLogin'] == 1 ? true : (json['isFirstLogin'] == null ? true : false)),
      email: json['email'],
      address: json['address'],
      bloodType: json['bloodType'],
      avatar: json['avatar'],
    );
  }
}

class DoctorModel extends UserModel {
  final String doctorId;
  String? specialty;
  String? hospital;
  String? imageUrl;
  String? experience;
  double? rating;
  int? reviewCount;
  double? fee;
  String? bio;

  DoctorModel({
    required String account,
    required String password,
    required this.doctorId,
    String? name,
    this.specialty,
    this.hospital,
    this.imageUrl,
    this.experience,
    this.rating,
    this.reviewCount,
    this.fee,
    this.bio,
  }) : super(account: account, password: password, name: name);
}

class AdminModel extends UserModel {
  AdminModel({required String account, required String password})
      : super(account: account, password: password);
}

class AppDatabase {
  // Singleton pattern
  AppDatabase._privateConstructor();
  static final AppDatabase instance = AppDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create Users table
    await db.execute('''
      CREATE TABLE users (
        account TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        name TEXT,
        dob TEXT,
        isMale INTEGER,
        isFirstLogin INTEGER NOT NULL DEFAULT 1,
        email TEXT,
        address TEXT,
        bloodType TEXT,
        avatar TEXT
      )
    ''');

    // Create Admins table
    await db.execute('''
      CREATE TABLE admins (
        account TEXT PRIMARY KEY,
        password TEXT NOT NULL
      )
    ''');

    // Create Doctors table
    await db.execute('''
      CREATE TABLE doctors (
        account TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        doctorId TEXT NOT NULL,
        name TEXT,
        specialty TEXT,
        hospital TEXT,
        imageUrl TEXT,
        experience TEXT,
        rating REAL DEFAULT 0,
        reviewCount INTEGER DEFAULT 0,
        fee REAL DEFAULT 0,
        bio TEXT
      )
    ''');

    // Create Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userAccount TEXT NOT NULL REFERENCES users(account),
        doctorAccount TEXT NOT NULL REFERENCES doctors(account),
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        note TEXT,
        fee REAL,
        createdAt TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    // Create Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userAccount TEXT NOT NULL REFERENCES users(account),
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'general',
        isRead INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    // Create Reviews table
    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doctorAccount TEXT NOT NULL REFERENCES doctors(account),
        userAccount TEXT NOT NULL REFERENCES users(account),
        appointmentId INTEGER REFERENCES appointments(id),
        rating REAL NOT NULL,
        comment TEXT,
        createdAt TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    // Create Medical Records table
    await db.execute('''
      CREATE TABLE medical_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userAccount TEXT NOT NULL REFERENCES users(account),
        doctorAccount TEXT NOT NULL REFERENCES doctors(account),
        appointmentId INTEGER REFERENCES appointments(id),
        diagnosis TEXT,
        symptoms TEXT,
        treatment TEXT,
        visitDate TEXT NOT NULL,
        followUpDate TEXT,
        notes TEXT
      )
    ''');

    // Create Prescriptions table
    await db.execute('''
      CREATE TABLE prescriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicalRecordId INTEGER NOT NULL REFERENCES medical_records(id),
        medicineName TEXT NOT NULL,
        dosage TEXT,
        frequency TEXT,
        duration TEXT,
        instructions TEXT
      )
    ''');

    // Create Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        userAccount TEXT NOT NULL REFERENCES users(account),
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');
  }

  Future<void> init() async {
    final db = await instance.database;
    final prefs = await SharedPreferences.getInstance();

    // 1. Data Migration from SharedPreferences to SQLite for Users
    final String? usersJson = prefs.getString('users_db');
    if (usersJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(usersJson);
        for (var item in decodedList) {
          final user = UserModel.fromJson(item);
          // Insert, ignore if conflicts (already migrated)
          await db.insert('users', {
            'account': user.account,
            'password': user.password,
            'name': user.name,
            'dob': user.dob,
            'isMale': user.isMale != null ? (user.isMale! ? 1 : 0) : null,
            'isFirstLogin': user.isFirstLogin ? 1 : 0,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        // Remove from SharedPreferences so we don't migrate again
        await prefs.remove('users_db');
      } catch (e) {
        // Handle migration error
        print("Migration error: \$e");
      }
    } else {
      // Seed fallback mock users if DB is completely empty and no SharedPreferences exists
      // Check if users table is empty
      final List<Map<String, dynamic>> existingUsers = await db.query('users', limit: 1);
      if (existingUsers.isEmpty) {
        await db.insert('users', {
          'account': '0987654321', 
          'password': '123456', 
          'name': 'Khách hàng Test 1', 
          'dob': '01/01/1990', 
          'isMale': 1,
          'isFirstLogin': 0,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
        await db.insert('users', {
          'account': '0896480152', 
          'password': '123456', 
          'name': 'Khách hàng Test 2', 
          'dob': '15/05/2000', 
          'isMale': 0,
          'isFirstLogin': 0,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    // 2. Seed Admin data
    await db.insert('admins', {
      'account': '0987654321',
      'password': '123456',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // 3. Seed Doctor data
    final List<Map<String, dynamic>> existingDoctors = await db.query('doctors', limit: 1);
    if (existingDoctors.isEmpty) {
      await db.insert('doctors', {
        'account': '0123456789',
        'password': '123456',
        'doctorId': 'BS001',
        'name': 'BS. Nguyễn Văn An',
        'specialty': 'Tim mạch',
        'hospital': 'BV Chợ Rẫy',
        'imageUrl': 'assests/images/bacsi_1.jpg',
        'experience': '10 năm',
        'rating': 4.8,
        'reviewCount': 120,
        'fee': 300000,
        'bio': 'Bác sĩ An có hơn 10 năm kinh nghiệm trong lĩnh vực Tim mạch.',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      await db.insert('doctors', {
        'account': '0923456789',
        'password': '123456',
        'doctorId': 'BS002',
        'name': 'BS. Trần Thị Bình',
        'specialty': 'Nhi khoa',
        'hospital': 'BV Nhi Đồng 1',
        'imageUrl': 'assests/images/bacsi_2.jpg',
        'experience': '8 năm',
        'rating': 4.9,
        'reviewCount': 85,
        'fee': 250000,
        'bio': 'Bác sĩ Bình chuyên khoa Nhi, luôn tận tâm và yêu thương trẻ nhỏ.',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // 4. Seed Appointments
    final List<Map<String, dynamic>> existingAppointments = await db.query('appointments', limit: 1);
    if (existingAppointments.isEmpty) {
      await db.insert('appointments', {
        'userAccount': '0987654321',
        'doctorAccount': '0123456789',
        'date': '2026-04-05',
        'time': '09:00',
        'status': 'confirmed',
        'fee': 300000,
      });

      await db.insert('appointments', {
        'userAccount': '0987654321',
        'doctorAccount': '0923456789',
        'date': '2026-03-28',
        'time': '14:30',
        'status': 'completed',
        'fee': 250000,
      });
    }

    // 5. Seed Notifications
    final List<Map<String, dynamic>> existingNotifications = await db.query('notifications', limit: 1);
    if (existingNotifications.isEmpty) {
      await db.insert('notifications', {
        'userAccount': '0987654321',
        'title': 'Nhắc lịch khám',
        'body': 'Bạn có lịch khám với BS. Nguyễn Văn An vào 09:00 ngày 05/04/2026.',
        'type': 'reminder',
        'isRead': 0,
      });

      await db.insert('notifications', {
        'userAccount': '0987654321',
        'title': 'Lịch hẹn được xác nhận',
        'body': 'Lịch hẹn ngày 03/04/2026 với BS. Trần Thị Bình đã được xác nhận.',
        'type': 'confirmed',
        'isRead': 0,
      });
    }

    // 6. Seed Reviews
    final List<Map<String, dynamic>> existingReviews = await db.query('reviews', limit: 1);
    if (existingReviews.isEmpty) {
      await db.insert('reviews', {
        'doctorAccount': '0123456789',
        'userAccount': '0987654321',
        'rating': 5.0,
        'comment': 'Bác sĩ rất tận tâm và chuyên nghiệp.',
      });

      await db.insert('reviews', {
        'doctorAccount': '0923456789',
        'userAccount': '0987654321',
        'rating': 4.5,
        'comment': 'Khám rất kỹ lưỡng, tư vấn chi tiết.',
      });
    }

    // 7. Seed Medical Records & Prescriptions
    final List<Map<String, dynamic>> existingRecords = await db.query('medical_records', limit: 1);
    if (existingRecords.isEmpty) {
      int recordId = await db.insert('medical_records', {
        'userAccount': '0987654321',
        'doctorAccount': '0923456789',
        'appointmentId': 2,
        'diagnosis': 'Viêm họng cấp',
        'symptoms': 'Đau họng, sốt nhẹ',
        'treatment': 'Uống kháng sinh amoxicillin 500mg',
        'visitDate': '2026-03-28',
      });

      await db.insert('prescriptions', {
        'medicalRecordId': recordId,
        'medicineName': 'Amoxicillin 500mg',
        'dosage': '1 viên',
        'frequency': '3 lần/ngày',
        'duration': '7 ngày',
        'instructions': 'Uống sau bữa ăn',
      });
    }
  }

  // Register a standard user
  Future<bool> registerUser(String account, String password) async {
    final db = await instance.database;
    try {
      final id = await db.insert('users', {
        'account': account,
        'password': password,
        'isFirstLogin': 1,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
      return id != 0;
    } catch (e) {
      // Typically a Unique constraint error if account exists
      return false;
    }
  }

  // Get user by account
  Future<UserModel?> getUserByAccount(String account) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'account = ?',
      whereArgs: [account],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  // Check if account exists (Users or Doctors, ignore Admin for forgot password)
  Future<bool> checkAccountExists(String account) async {
    final db = await instance.database;
    final userCursor = await db.query('users', where: 'account = ?', whereArgs: [account]);
    if (userCursor.isNotEmpty) return true;

    final doctorCursor = await db.query('doctors', where: 'account = ?', whereArgs: [account]);
    return doctorCursor.isNotEmpty;
  }

  // Check login for User
  Future<bool> loginUser(String account, String password) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'account = ? AND password = ?',
      whereArgs: [account, password],
    );
    return maps.isNotEmpty;
  }

  // Check login for Admin
  Future<bool> loginAdmin(String account, String password) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'admins',
      where: 'account = ? AND password = ?',
      whereArgs: [account, password],
    );
    return maps.isNotEmpty;
  }

  // Check login for Doctor
  Future<bool> loginDoctor(String account, String password, String doctorId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'doctors',
      where: 'account = ? AND password = ? AND doctorId = ?',
      whereArgs: [account, password, doctorId],
    );
    return maps.isNotEmpty;
  }

  // Update User Profile
  Future<bool> updateUserProfile(String account, String name, String dob, bool isMale) async {
    final db = await instance.database;
    final int rowsUpdated = await db.update(
      'users',
      {
        'name': name,
        'dob': dob,
        'isMale': isMale ? 1 : 0,
        'isFirstLogin': 0,
      },
      where: 'account = ?',
      whereArgs: [account],
    );
    return rowsUpdated > 0;
  }

  // Mark first login as done
  Future<void> markFirstLoginDone(String account) async {
    final db = await instance.database;
    await db.update(
      'users',
      {'isFirstLogin': 0},
      where: 'account = ? AND isFirstLogin = ?',
      whereArgs: [account, 1],
    );
  }

  // Update password (checks across users, admins, and doctors)
  Future<bool> updatePassword(String account, String newPassword) async {
    final db = await instance.database;
    bool updated = false;

    int rowsUser = await db.update('users', {'password': newPassword}, where: 'account = ?', whereArgs: [account]);
    if (rowsUser > 0) updated = true;

    int rowsAdmin = await db.update('admins', {'password': newPassword}, where: 'account = ?', whereArgs: [account]);
    if (rowsAdmin > 0) updated = true;

    int rowsDoctor = await db.update('doctors', {'password': newPassword}, where: 'account = ?', whereArgs: [account]);
    if (rowsDoctor > 0) updated = true;

    return updated;
  }
}
