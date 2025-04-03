import 'package:flutter/material.dart';
import 'dashboard_admin.dart'; // Import the Admin Dashboard
import 'signup_admin.dart'; // Import Sign Up Admin Page
import '../../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({Key? key}) : super(key: key);

  @override
  _LoginAdminPageState createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Email validation
  bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  // Validate login input
Future<void> loginAdmin() async {
  if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter both email and password")));
    return;
  }

  if (!isEmailValid(emailController.text.trim())) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a valid email address")));
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    AuthService authService = AuthService();
    var user = await authService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

  if (user != null) {
    // 🔍 Search all schools for this admin
    final schools = await FirebaseFirestore.instance.collection('schools').get();

    DocumentSnapshot? adminDoc;
    String foundSchoolDomain = '';
    String adminName = '';

    for (var school in schools.docs) {
      var adminSnapshot = await FirebaseFirestore.instance
          .collection('schools')
          .doc(school.id)
          .collection('admins')
          .doc(user.uid)
          .get();

      if (adminSnapshot.exists) {
        adminDoc = adminSnapshot;
        foundSchoolDomain = school.id; // this is your schoolDomain
        adminName = adminSnapshot['fullName'] ?? 'Admin';
        break;
      }
    }

    if (adminDoc != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminDashboardPage(
            schoolDomain: foundSchoolDomain,
            adminName: adminName,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Admin profile not found.")),
      );
    }
  }
 else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid credentials")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Login")),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome Admin!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            // Email input with validation
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            // Password input
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 30),
            // Login button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : loginAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Login", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20),
            // Sign-up navigation
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpAdminPage()), // Navigate to the Sign Up Admin Page
                );
              },
              child: Text("Don't have an account? Sign Up here", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
