import 'package:care4u_medical_booking/shared/database/database_helper.dart';

class ReviewDao {
  final _db = DatabaseHelper.instance;

  Future<int> insert(Map<String, dynamic> review) async {
    final db = await _db.database;
    return db.insert('reviews', review);
  }

  Future<List<Map<String, dynamic>>> getByDoctor(int doctorId) async {
    final db = await _db.database;
    return db.rawQuery('''
      SELECT r.*, u.name AS userName
      FROM reviews r
      JOIN users u ON r.userId = u.id
      WHERE r.doctorId = ?
      ORDER BY r.createdAt DESC
    ''', [doctorId]);
  }

  Future<bool> hasReviewed(int userId, int doctorId) async {
    final db = await _db.database;
    final result = await db.query('reviews',
        where: 'userId = ? AND doctorId = ?',
        whereArgs: [userId, doctorId]);
    return result.isNotEmpty;
  }

  Future<double> avgRating(int doctorId) async {
    final db = await _db.database;
    final result = await db.rawQuery(
        'SELECT AVG(rating) as avg FROM reviews WHERE doctorId = ?',
        [doctorId]);
    return (result.first['avg'] as num?)?.toDouble() ?? 0.0;
  }
}
