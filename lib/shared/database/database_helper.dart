import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Central SQLite database helper for Care4U.
/// 
/// Tables:
/// - users          : patient & doctor accounts
/// - doctors        : doctor profiles
/// - appointments   : booking records
/// - notifications  : push/local notification records
/// - reviews        : doctor ratings & comments
/// - medical_records: patient visit history
/// - prescriptions  : prescriptions linked to records
class DatabaseHelper {
  static const _databaseName = 'care4u.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        name      TEXT    NOT NULL,
        email     TEXT,
        phone     TEXT    NOT NULL UNIQUE,
        password  TEXT    NOT NULL,
        role      TEXT    NOT NULL DEFAULT 'patient',  -- patient | doctor | admin
        dob       TEXT,
        gender    TEXT,
        address   TEXT,
        bloodType TEXT,
        createdAt TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE doctors (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        userId      INTEGER REFERENCES users(id),
        name        TEXT    NOT NULL,
        specialty   TEXT    NOT NULL,
        hospital    TEXT,
        imageUrl    TEXT,
        licenseId   TEXT    UNIQUE,
        experience  TEXT,
        rating      REAL    DEFAULT 0,
        reviewCount INTEGER DEFAULT 0,
        fee         REAL    DEFAULT 0,
        bio         TEXT,
        isActive    INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE appointments (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        userId      INTEGER NOT NULL REFERENCES users(id),
        doctorId    INTEGER NOT NULL REFERENCES doctors(id),
        date        TEXT    NOT NULL,
        time        TEXT    NOT NULL,
        status      TEXT    NOT NULL DEFAULT 'pending',  -- pending|confirmed|completed|cancelled
        note        TEXT,
        fee         REAL,
        createdAt   TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        userId    INTEGER NOT NULL REFERENCES users(id),
        title     TEXT    NOT NULL,
        body      TEXT    NOT NULL,
        type      TEXT    NOT NULL DEFAULT 'general',   -- reminder|confirmed|cancelled|result|general
        isRead    INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        doctorId      INTEGER NOT NULL REFERENCES doctors(id),
        userId        INTEGER NOT NULL REFERENCES users(id),
        appointmentId INTEGER REFERENCES appointments(id),
        rating        REAL    NOT NULL,
        comment       TEXT,
        createdAt     TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE medical_records (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        userId        INTEGER NOT NULL REFERENCES users(id),
        doctorId      INTEGER NOT NULL REFERENCES doctors(id),
        appointmentId INTEGER REFERENCES appointments(id),
        diagnosis     TEXT,
        symptoms      TEXT,
        treatment     TEXT,
        visitDate     TEXT    NOT NULL,
        followUpDate  TEXT,
        notes         TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE prescriptions (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        medicalRecordId INTEGER NOT NULL REFERENCES medical_records(id),
        medicineName    TEXT    NOT NULL,
        dosage          TEXT,
        frequency       TEXT,
        duration        TEXT,
        instructions    TEXT
      )
    ''');

    // Seed demo data
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    // ── Users ────────────────────────────────────────────────────────────────
    await db.insert('users', {
      'name': 'Nguyễn Thị Lan',
      'email': 'lan@gmail.com',
      'phone': '0901234567',
      'password': '123456',
      'role': 'patient',
      'dob': '1990-05-15',
      'gender': 'Nữ',
      'address': '123 Nguyễn Trãi, Q.5, TP.HCM',
      'bloodType': 'A+',
    });

    await db.insert('users', {
      'name': 'BS. Nguyễn Văn An',
      'email': 'bsan@care4u.vn',
      'phone': '0912345678',
      'password': 'doctor123',
      'role': 'doctor',
    });

    await db.insert('users', {
      'name': 'BS. Trần Thị Bình',
      'email': 'bsbinh@care4u.vn',
      'phone': '0923456789',
      'password': 'doctor123',
      'role': 'doctor',
    });

    // ── Doctors ──────────────────────────────────────────────────────────────
    await db.insert('doctors', {
      'userId': 2,
      'name': 'BS. Nguyễn Văn An',
      'specialty': 'Tim mạch',
      'hospital': 'BV Chợ Rẫy',
      'imageUrl': 'assests/images/bacsi_1.jpg',
      'licenseId': 'BS-2025-001',
      'experience': '10 năm',
      'rating': 4.8,
      'reviewCount': 120,
      'fee': 300000,
      'bio': 'Bác sĩ An có hơn 10 năm kinh nghiệm trong lĩnh vực Tim mạch.',
    });

    await db.insert('doctors', {
      'userId': 3,
      'name': 'BS. Trần Thị Bình',
      'specialty': 'Nhi khoa',
      'hospital': 'BV Nhi Đồng 1',
      'imageUrl': 'assests/images/bacsi_2.jpg',
      'licenseId': 'BS-2025-002',
      'experience': '8 năm',
      'rating': 4.9,
      'reviewCount': 85,
      'fee': 250000,
      'bio': 'Bác sĩ Bình chuyên khoa Nhi, luôn tận tâm và yêu thương trẻ nhỏ.',
    });

    // ── Appointments ─────────────────────────────────────────────────────────
    await db.insert('appointments', {
      'userId': 1,
      'doctorId': 1,
      'date': '2026-04-05',
      'time': '09:00',
      'status': 'confirmed',
      'fee': 300000,
    });

    await db.insert('appointments', {
      'userId': 1,
      'doctorId': 2,
      'date': '2026-03-28',
      'time': '14:30',
      'status': 'completed',
      'fee': 250000,
    });

    // ── Notifications ────────────────────────────────────────────────────────
    await db.insert('notifications', {
      'userId': 1,
      'title': 'Nhắc lịch khám',
      'body': 'Bạn có lịch khám với BS. Nguyễn Văn An vào 09:00 ngày 05/04/2026.',
      'type': 'reminder',
      'isRead': 0,
    });

    await db.insert('notifications', {
      'userId': 1,
      'title': 'Lịch hẹn được xác nhận',
      'body': 'Lịch hẹn ngày 03/04/2026 với BS. Trần Thị Bình đã được xác nhận.',
      'type': 'confirmed',
      'isRead': 0,
    });

    // ── Reviews ──────────────────────────────────────────────────────────────
    await db.insert('reviews', {
      'doctorId': 1,
      'userId': 1,
      'rating': 5.0,
      'comment': 'Bác sĩ rất tận tâm và chuyên nghiệp.',
    });

    await db.insert('reviews', {
      'doctorId': 2,
      'userId': 1,
      'rating': 4.5,
      'comment': 'Khám rất kỹ lưỡng, tư vấn chi tiết.',
    });

    // ── Medical Records ──────────────────────────────────────────────────────
    await db.insert('medical_records', {
      'userId': 1,
      'doctorId': 2,
      'appointmentId': 2,
      'diagnosis': 'Viêm họng cấp',
      'symptoms': 'Đau họng, sốt nhẹ',
      'treatment': 'Uống kháng sinh amoxicillin 500mg',
      'visitDate': '2026-03-28',
    });

    // ── Prescriptions ─────────────────────────────────────────────────────────
    await db.insert('prescriptions', {
      'medicalRecordId': 1,
      'medicineName': 'Amoxicillin 500mg',
      'dosage': '1 viên',
      'frequency': '3 lần/ngày',
      'duration': '7 ngày',
      'instructions': 'Uống sau bữa ăn',
    });
  }
}
