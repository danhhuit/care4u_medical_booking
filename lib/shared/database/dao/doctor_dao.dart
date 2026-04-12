import 'package:care4u_medical_booking/shared/database/database_helper.dart';

class DoctorDao {
  final _db = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    final db = await _db.database;
    return db.query('doctors');
  }

  Future<List<Map<String, dynamic>>> getDoctorsBySpecialty(String specialty) async {
    final db = await _db.database;
    return db.query('doctors',
        where: 'specialty = ? AND isActive = 1', whereArgs: [specialty]);
  }

  Future<Map<String, dynamic>?> getDoctorById(int id) async {
    final db = await _db.database;
    final rows = await db.query('doctors', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<List<Map<String, dynamic>>> searchDoctors(String query) async {
    final db = await _db.database;
    return db.query(
      'doctors',
      where: "(name LIKE ? OR specialty LIKE ?) AND isActive = 1",
      whereArgs: ['%$query%', '%$query%'],
    );
  }

  Future<int> insertDoctor(Map<String, dynamic> doctor) async {
    final db = await _db.database;
    return db.insert('doctors', doctor);
  }

  Future<int> updateDoctor(int id, Map<String, dynamic> fields) async {
    final db = await _db.database;
    return db.update('doctors', fields, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> recalcRating(int doctorId) async {
    final db = await _db.database;
    final result = await db.rawQuery(
        'SELECT AVG(rating) as avg, COUNT(*) as count FROM reviews WHERE doctorId = ?',
        [doctorId]);
    if (result.isNotEmpty) {
      final avg = (result.first['avg'] as num?)?.toDouble() ?? 0.0;
      final count = (result.first['count'] as int?) ?? 0;
      await db.update(
        'doctors',
        {'rating': avg, 'reviewCount': count},
        where: 'id = ?',
        whereArgs: [doctorId],
      );
    }
  }
}
