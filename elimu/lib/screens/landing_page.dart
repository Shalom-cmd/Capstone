import 'package:flutter/material.dart';
import 'login_teacher.dart';
import 'login_student.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ELIMU',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            _buildRoleButton(context, "Student"),
            _buildRoleButton(context, "Teacher"),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          // Navigate to the correct login page based on role
          if (role == "Student") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginStudentPage()),
            );
          } else if (role == "Teacher") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginTeacherPage()),
            );
          }
        },
        child: Text(
          "I am a $role",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
    );
  }
}
