import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/google_auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final GoogleAuthService authService = GoogleAuthService();

  Future<void> saveUserToDatabase(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse(
          'http://localhost:3000/api/users',
        ), // Replace with your actual backend URL
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        print("User saved successfully");
      } else {
        print("Failed to save user: ${response.body}");
      }
    } catch (e) {
      print("Error saving user to database: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await authService.signIn();
            if (user != null) {
              // Prepare user data for MongoDB
              Map<String, dynamic> userData = {
                "name": user.displayName,
                "email": user.email,
                "photoUrl": user.photoUrl,
              };

              // Save user data to MongoDB
              await saveUserToDatabase(userData);

              // Navigate to HomeScreen
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
