import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
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
      // Search across all schools
      final schools = await FirebaseFirestore.instance.collection('schools').get();

      DocumentSnapshot? studentDoc;
      String studentFullName = '';
      String parentEmail = '';

      for (var school in schools.docs) {
        final query = await FirebaseFirestore.instance
            .collection('schools')
            .doc(school.id)
            .collection('students')
            .where('username', isEqualTo: usernameController.text.trim())
            .get();

        if (query.docs.isNotEmpty) {
          studentDoc = query.docs.first;
          studentFullName = studentDoc['fullName'] ?? 'Student';
          parentEmail = studentDoc['parentEmail'];
          break;
        }
      }

      if (studentDoc != null) {
        // Use parent's email for Firebase login
        AuthService authService = AuthService();
        var user = await authService.loginUser(parentEmail, passwordController.text.trim());

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅ Login Successful!")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentDashboard(fullName: studentFullName)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your password was not correct, please try again.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("We couldn’t find your username. Please check your spelling.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Oops! Something went wrong. Try again.")),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "🎉 Welcome Back, Student!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 30),

              // Username input
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "e.g. Emma-Grade 1",
                ),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Password input (always visible)
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "e.g. TigerBlue7",
                ),
                obscureText: false,
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
                      : Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),

              SizedBox(height: 20),

              // Sign-up redirect
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpStudentPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign up here!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              ),

              SizedBox(height: 30),

              // Fun Tip!
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("💡 Fun Tip!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                      SizedBox(height: 10),
                      Text(
                        "Use your special username (like Emma-Grade 1) and your fun password to log in!",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Your password is like a magic key that only you and your teacher know! 🔑✨",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
