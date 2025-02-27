import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'dashboard_student.dart';
import 'signup_student.dart';

class LoginStudentPage extends StatefulWidget {
  const LoginStudentPage({Key? key}) : super(key: key);

  @override
  _LoginStudentPageState createState() => _LoginStudentPageState();
}

class _LoginStudentPageState extends State<LoginStudentPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Retrieve email and fullName using username from Firestore
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: usernameController.text.trim())
          .get();

      if (query.docs.isNotEmpty) {
        String email = query.docs.first.get('parentEmail'); // Fetch parent's email
        String fullName = query.docs.first.get('fullName'); // Fetch student full name

        // Firebase Auth
        AuthService authService = AuthService();
        var user = await authService.loginUser(email, passwordController.text.trim());

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅ Login Successful!")),
          );

          // Student dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentDashboard(fullName: fullName)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your password was not correct, please try again.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("We could not find your username, please check your spelling.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("We couldn't log you in, please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Login")),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome Back! We are glad you are here!🎉",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 20),

            // Username field with hint
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                hintText: "Hint: It's your first name, an animal & two numbers",
              ),
              style: TextStyle(fontSize: 18),
            ),

            // Password field with hint
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Hint: It's your favorite animal, favorite color & favorite number (example: TigerBlue7)",
              ),
              obscureText: false, // make password visible
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Login",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpStudentPage()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
                child: Text(
                  "If you don't have an account, we could get you signed up!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Fun fact section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "💡 Fun Fact!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "A username is a special nickname you use online and is a way to tell everyone who you are.",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "A password keeps your information safe. Imagine a special word that only you and your favorite stuffed animal know. That's your password! 🤫🔒",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
