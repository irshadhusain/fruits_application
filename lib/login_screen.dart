import 'package:flutter/material.dart';
import 'package:fruits_applicatiopn/shared_preferences.dart';

import 'authentication_ service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final token = await _authService.authenticate(username, password);
      SharedPreferenceStorage.sharedPreferenceStorage.saveToken(token ?? "");

      print("********************${token}");
      // Store the token securely (e.g., in shared preferences or secure storage)
      print('Authenticated successfully with token: $token');
      // Navigate to the next screen or perform other actions
    } catch (e) {
      print('Authentication failed: $e');
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
              onPressed: () {
                _login();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
