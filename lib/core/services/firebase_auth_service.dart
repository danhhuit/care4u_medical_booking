import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService._();
  static final FirebaseAuthService instance = FirebaseAuthService._();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _toEmail(String account) {
    if (account.contains('@')) return account;
    return '$account@care4u.vn';
  }

  // Chuyển đổi số điện thoại Việt Nam sang định dạng E.164 (+84...)
  String formatPhoneNumber(String phone) {
    if (phone.startsWith('0')) {
      return '+84${phone.substring(1)}';
    } else if (!phone.startsWith('+')) {
      return '+84$phone';
    }
    return phone;
  }

  // Gọi API Firebase gửi SMS
  Future<void> verifyPhoneNumber({
    required String phone,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(FirebaseAuthException e) verificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: formatPhoneNumber(phone),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Tự động xác thực thành công (thường trên Android)
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<User?> loginUser(String account, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _toEmail(account),
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<User?> registerUser(String account, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: _toEmail(account),
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  Future<bool> updatePassword(String account, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
         return false;
      }
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      print('Update password error: $e');
      return false;
    }
  }

  Future<bool> checkAccountExists(String account) async {
    try {
      // Phương thức fetchSignInMethodsForEmail đã bị Firebase xóa trong các bản SDK mới
      // để chống dò rỉ email (Email Enumeration Protection).
      // Cách thay thế tạm thời là thử đăng nhập bằng mật khẩu sai.
      await _auth.signInWithEmailAndPassword(
        email: _toEmail(account),
        password: 'FakePasswordForCheck123!@#',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false;
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        // Lưu ý: Nếu Firebase bật tính năng bảo mật Email Enumeration Protection, 
        // nó sẽ luôn trả về 'invalid-credential'. Ta tạm mặc định là tài khoản tồn tại 
        // để cho phép luồng chạy tiếp.
        return true;
      }
      return false;
    } catch (e) {
      print('Check account error: $e');
      return false;
    }
  }

  Future<User?> loginAdmin(String account, String password) async {
    // Trong thực tế, bạn sẽ kiểm tra role ở database (Firestore) hoặc qua Custom Claims
    // Ở đây dùng chung login của Firebase Auth
    return await loginUser(account, password);
  }

  Future<User?> loginDoctor(String phone, String password, String doctorId) async {
    // Tương tự admin, loginDoctor cần check role
    return await loginUser(phone, password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
