import 'package:flutter/material.dart';
import 'dart:math';
import '../services/auth_service.dart';

class SignUpStudentPage extends StatefulWidget {
  const SignUpStudentPage({Key? key}) : super(key: key);

  @override
  _SignUpStudentPageState createState() => _SignUpStudentPageState();
}

class _SignUpStudentPageState extends State<SignUpStudentPage> {
  // Section 1: Teacher/Parent Input
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController classCodeController = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();

  // Section 2: Student Input
  final TextEditingController studentFirstNameController = TextEditingController();
  final TextEditingController favoriteAnimalController = TextEditingController();
  final TextEditingController favoriteColorController = TextEditingController();
  final TextEditingController favoriteNumberController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String generatedUsername = "";
  String generatedPassword = "";

  final List<String> animalNames = [
    "Tiger", "Penguin", "Lion", "Dolphin", "Giraffe", "Elephant", "Panda", "Koala", "Zebra"
  ];

  String generateUsername(String firstName) {
    final random = Random();
    String animal = animalNames[random.nextInt(animalNames.length)];
    int number = random.nextInt(99) + 1;
    return "$firstName$animal$number";
  }

  String generatePassword(String animal, String color, String number) {
    return "${animal[0].toUpperCase()}${animal.substring(1)}"
           "${color[0].toUpperCase()}${color.substring(1)}"
           "$number"; 
  }

  void createStudentAccount() async {
    if (generatedUsername.isEmpty || generatedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please generate a username & password first!")),
      );
      return;
    }

    if (generatedPassword != confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    AuthService authService = AuthService();
    var user = await authService.signUpUser(
      generatedUsername,
      parentEmailController.text.trim(),
      generatedPassword,
      "student",
    );

    if (!mounted) return;
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student Registered Successfully!")),
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
      appBar: AppBar(title: Text("Student Sign-Up")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Teacher Input
            Text("👩‍🏫 To be filled out by teacher/parent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: firstNameController, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: lastNameController, decoration: InputDecoration(labelText: "Last Name")),
            TextField(controller: gradeController, decoration: InputDecoration(labelText: "Grade")),
            TextField(controller: classCodeController, decoration: InputDecoration(labelText: "Class Code")),
            TextField(controller: parentEmailController, decoration: InputDecoration(labelText: "Parent Email")),

            SizedBox(height: 20),

            // Section 2: Student Input
            Text("🧒 For the student", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: studentFirstNameController, decoration: InputDecoration(labelText: "Your First Name")),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  generatedUsername = generateUsername(studentFirstNameController.text);
                });
              },
              child: Text("Generate Username"),
            ),
            Text("Generated Username: $generatedUsername", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),

            // Password Generation
            Text("Create a fun password!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: favoriteAnimalController, decoration: InputDecoration(labelText: "Favorite Animal")),
            TextField(controller: favoriteColorController, decoration: InputDecoration(labelText: "Favorite Color")),
            TextField(controller: favoriteNumberController, decoration: InputDecoration(labelText: "Favorite One-Digit Number")),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  generatedPassword = generatePassword(
                    favoriteAnimalController.text.trim(),
                    favoriteColorController.text.trim(),
                    favoriteNumberController.text.trim(),
                  );
                });
              },
              child: Text("Generate Password"),
            ),
            Text("Generated Password: $generatedPassword", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: "Confirm Password")),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createStudentAccount,
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
