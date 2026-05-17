import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> saveUserProfile(String account, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(account).set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Save profile error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String account) async {
    try {
      final doc = await _firestore.collection('users').doc(account).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  Future<bool> markFirstLoginDone(String account) async {
    try {
      await _firestore.collection('users').doc(account).set(
        {'isFirstLogin': false}, 
        SetOptions(merge: true)
      );
      return true;
    } catch (e) {
      print('Mark first login done error: $e');
      return false;
    }
  }
}
