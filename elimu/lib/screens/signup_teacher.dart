import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpTeacherPage extends StatefulWidget {
  const SignUpTeacherPage({Key? key}) : super(key: key);

  @override
  _SignUpTeacherPageState createState() => _SignUpTeacherPageState();
}

class _SignUpTeacherPageState extends State<SignUpTeacherPage> {
  // Teacher input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController gradeLevelController = TextEditingController(); 
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  List<Map<String, dynamic>> subjects = []; // Stores subject and years info

  String selectedSubject = "Math"; // Default selected subject
  TextEditingController yearsOfExperienceController = TextEditingController();

  final List<String> subjectList = [
    "English", "Math", "Art", "Science", "History", "Music", "Geography", 
    "P.E (Physical Education)", "Drama", "Biology", "Chemistry", "Physics", 
    "Foreign Languages", "Social Studies", "Literature", "Algebra", "Geometry"
  ];

  Future<void> registerTeacher() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    // Create the teacher user in Firebase Auth
    AuthService authService = AuthService();
    var user = await authService.signUpUser(
      emailController.text.trim(),
      passwordController.text.trim(), 
      "teacher",                   
      "",                           
    );

    if (user != null) {
      await FirebaseFirestore.instance.collection('teachers').doc(user.uid).set({
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'gradeLevel': gradeLevelController.text.trim(),
        'subjects': subjects, 
        'role': "teacher",
        'uid': user.uid, 
        'createdAt': FieldValue.serverTimestamp(),
      });

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

  void addSubject() {
    if (yearsOfExperienceController.text.isNotEmpty) {
      setState(() {
        subjects.add({
          'subject': selectedSubject,
          'yearsOfExperience': yearsOfExperienceController.text.trim(),
        });
        yearsOfExperienceController.clear(); 
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the number of years taught")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Teacher Sign-Up")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: gradeLevelController, decoration: InputDecoration(labelText: "What grade Level do you teach?")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: "Confirm Password"), obscureText: true),

            SizedBox(height: 20),

            Text("👩‍🏫 Subjects You Teach", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedSubject,
              onChanged: (newValue) {
                setState(() {
                  selectedSubject = newValue!;
                });
              },
              items: subjectList.map((String subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
            ),
            TextField(
              controller: yearsOfExperienceController,
              decoration: InputDecoration(labelText: "Number of Years Teaching"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: addSubject,
              child: Text("Add Another Subject"),
            ),
            SizedBox(height: 10),

            Column(
              children: subjects.map((subject) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text("${subject['subject']}"),
                    subtitle: Text("Years of Experience: ${subject['yearsOfExperience']}"),
                  ),
                );
              }).toList(),
            ),

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
