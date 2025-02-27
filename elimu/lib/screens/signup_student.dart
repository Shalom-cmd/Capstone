import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class SignUpStudentPage extends StatefulWidget {
  const SignUpStudentPage({Key? key}) : super(key: key);

  @override
  _SignUpStudentPageState createState() => _SignUpStudentPageState();
}

class _SignUpStudentPageState extends State<SignUpStudentPage> {
  
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController addressConroller = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();


  final TextEditingController studentFirstNameController = TextEditingController();
  final TextEditingController favoriteAnimalController = TextEditingController();
  final TextEditingController favoriteColorController = TextEditingController();
  final TextEditingController favoriteNumberController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String generatedUsername = "";
  String generatedPassword = "";

  final List<String> animalNames = [
    "Tiger", "Penguin", "Lion", "Dolphin", "Giraffe", "Elephant", "Panda", "Koala", "Zebra", "Whale", "Dog", "Cat", "Hamster"
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
      parentEmailController.text.trim(), 
      generatedPassword,                 
      "student",                        
      generatedUsername,                 
    );

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'grade': gradeController.text.trim(),
        'address': addressConroller.text.trim(),
        'parentEmail': parentEmailController.text.trim(),
        'username': generatedUsername, 
        'role': "student",
        'uid': user.uid, 
      });

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
            TextField(controller: gradeController, decoration: InputDecoration(labelText: "Grade", hintText: "Enter: Kindergarten or Grade 1, or Grade 2..")),
            TextField(controller: addressConroller, decoration: InputDecoration(labelText: "Address", hintText: "Street address, City, State, Zip Code")),
            TextField(controller: parentEmailController, decoration: InputDecoration(labelText: "Parent Email")),

            SizedBox(height: 20),

            
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
