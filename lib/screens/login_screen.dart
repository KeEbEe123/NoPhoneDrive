import 'package:flutter/material.dart';
import '../services/google_auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final GoogleAuthService authService = GoogleAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await authService.signIn();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
