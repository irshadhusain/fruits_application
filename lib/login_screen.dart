import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fruits_applicatiopn/admin_screen.dart';
import 'package:fruits_applicatiopn/main.dart';
import 'package:fruits_applicatiopn/user_add_products.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final AuthService _authService = AuthService();

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> loginUsingEmailPassword(
      {required email,
      required String password,
      required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
      // Handle other exceptions...
    }
    return user;
  }

  // void _login() async {
  //   final email = _usernameController.text;
  //   final password = _passwordController.text;

  //   try {
  //     final token = await _authService.authenticate(email, password);
  //     SharedPreferenceStorage.sharedPreferenceStorage.saveToken(token ?? "");

  //     print("********************${token}");
  //     // Store the token securely (e.g., in shared preferences or secure storage)
  //     print('Authenticated successfully with token: $token');
  //     // Navigate to the next screen or perform other actions
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('please enter valid email')));
  //     // Show an error message to the user
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Call the login function
                User? user = await loginUsingEmailPassword(
                  email: _usernameController.text,
                  password: _passwordController.text,
                  context: context,
                );
                print("@@@@@@@@@@${user}");

                if (user?.email == "admin@gmail.com") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserAddedProducts()),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
