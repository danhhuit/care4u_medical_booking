import 'package:care4u_medical_booking/shared/database/database_helper.dart';

class NotificationDao {
  final _db = DatabaseHelper.instance;

  Future<int> insert(Map<String, dynamic> notification) async {
    final db = await _db.database;
    return db.insert('notifications', notification);
  }

  Future<List<Map<String, dynamic>>> getByUser(int userId) async {
    final db = await _db.database;
    return db.query('notifications',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'createdAt DESC');
  }

  Future<int> unreadCount(int userId) async {
    final db = await _db.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as cnt FROM notifications WHERE userId = ? AND isRead = 0',
        [userId]);
    return (result.first['cnt'] as int?) ?? 0;
  }

  Future<int> markRead(int id) async {
    final db = await _db.database;
    return db.update('notifications', {'isRead': 1},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> markAllRead(int userId) async {
    final db = await _db.database;
    return db.update('notifications', {'isRead': 1},
        where: 'userId = ?', whereArgs: [userId]);
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }
}
