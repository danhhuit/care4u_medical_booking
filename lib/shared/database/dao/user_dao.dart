import 'package:care4u_medical_booking/shared/database/database_helper.dart';

class UserDao {
  final _db = DatabaseHelper.instance;

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await _db.database;
    return db.insert('users', user);
  }

  Future<Map<String, dynamic>?> findByPhone(String phone) async {
    final db = await _db.database;
    final rows = await db.query('users', where: 'phone = ?', whereArgs: [phone]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<Map<String, dynamic>?> findById(int id) async {
    final db = await _db.database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<Map<String, dynamic>?> login(String phone, String password) async {
    final db = await _db.database;
    final rows = await db.query('users',
        where: 'phone = ? AND password = ?', whereArgs: [phone, password]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<int> updateUser(int id, Map<String, dynamic> fields) async {
    final db = await _db.database;
    return db.update('users', fields, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await _db.database;
    return db.query('users');
  }
}
