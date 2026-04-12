import 'package:care4u_medical_booking/shared/database/database_helper.dart';

class AppointmentDao {
  final _db = DatabaseHelper.instance;

  Future<int> insertAppointment(Map<String, dynamic> appointment) async {
    final db = await _db.database;
    return db.insert('appointments', appointment);
  }

  Future<List<Map<String, dynamic>>> getByUser(int userId) async {
    final db = await _db.database;
    return db.rawQuery('''
      SELECT a.*, d.name AS doctorName, d.specialty, d.imageUrl
      FROM appointments a
      JOIN doctors d ON a.doctorId = d.id
      WHERE a.userId = ?
      ORDER BY a.date DESC, a.time DESC
    ''', [userId]);
  }

  Future<List<Map<String, dynamic>>> getByDoctor(int doctorId) async {
    final db = await _db.database;
    return db.rawQuery('''
      SELECT a.*, u.name AS patientName, u.phone AS patientPhone
      FROM appointments a
      JOIN users u ON a.userId = u.id
      WHERE a.doctorId = ?
      ORDER BY a.date DESC, a.time DESC
    ''', [doctorId]);
  }

  Future<List<Map<String, dynamic>>> getByStatus(int userId, String status) async {
    final db = await _db.database;
    return db.rawQuery('''
      SELECT a.*, d.name AS doctorName, d.specialty, d.imageUrl
      FROM appointments a
      JOIN doctors d ON a.doctorId = d.id
      WHERE a.userId = ? AND a.status = ?
      ORDER BY a.date, a.time
    ''', [userId, status]);
  }

  Future<int> updateStatus(int id, String status) async {
    final db = await _db.database;
    return db.update('appointments', {'status': status},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTodayAppointments(int doctorId) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final db = await _db.database;
    return db.rawQuery('''
      SELECT a.*, u.name AS patientName
      FROM appointments a
      JOIN users u ON a.userId = u.id
      WHERE a.doctorId = ? AND a.date = ?
      ORDER BY a.time
    ''', [doctorId, today]);
  }
}
