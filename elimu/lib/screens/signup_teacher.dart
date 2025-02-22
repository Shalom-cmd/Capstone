import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpTeacherPage extends StatefulWidget {
  const SignUpTeacherPage({Key? key}) : super(key: key);

  @override
  _SignUpTeacherPageState createState() => _SignUpTeacherPageState();
}

class _SignUpTeacherPageState extends State<SignUpTeacherPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> registerTeacher() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    AuthService authService = AuthService();
    var user = await authService.signUpUser(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      "teacher",
    );

    if (!mounted) return;
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Teacher Registered Successfully!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Teacher Sign-Up")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: "Confirm Password"), obscureText: true),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: registerTeacher,
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
