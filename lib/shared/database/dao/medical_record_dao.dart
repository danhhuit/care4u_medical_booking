import 'package:care4u_medical_booking/shared/database/database_helper.dart';

class MedicalRecordDao {
  final _db = DatabaseHelper.instance;

  Future<int> insert(Map<String, dynamic> record) async {
    final db = await _db.database;
    return db.insert('medical_records', record);
  }

  Future<List<Map<String, dynamic>>> getByUser(int userId) async {
    final db = await _db.database;
    return db.rawQuery('''
      SELECT mr.*, d.name AS doctorName, d.specialty
      FROM medical_records mr
      JOIN doctors d ON mr.doctorId = d.id
      WHERE mr.userId = ?
      ORDER BY mr.visitDate DESC
    ''', [userId]);
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    final db = await _db.database;
    final rows = await db.query('medical_records', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<List<Map<String, dynamic>>> getPrescriptions(int recordId) async {
    final db = await _db.database;
    return db.query('prescriptions',
        where: 'medicalRecordId = ?', whereArgs: [recordId]);
  }

  Future<int> insertPrescription(Map<String, dynamic> prescription) async {
    final db = await _db.database;
    return db.insert('prescriptions', prescription);
  }
}
