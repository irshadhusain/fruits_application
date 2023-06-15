import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> authenticate(String username, String password) async {
    try {
      // Sign in with email and password
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      // Get the user token
      final idTokenResult = await userCredential.user!.getIdTokenResult();

      return idTokenResult.token;
    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }
  }

  // You can add additional methods for token refreshing, logout, etc.
}