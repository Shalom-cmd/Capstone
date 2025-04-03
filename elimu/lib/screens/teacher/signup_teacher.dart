import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';

class SignUpTeacherPage extends StatefulWidget {
  const SignUpTeacherPage({Key? key}) : super(key: key);

  @override
  _SignUpTeacherPageState createState() => _SignUpTeacherPageState();
}

class _SignUpTeacherPageState extends State<SignUpTeacherPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController gradeLevelController = TextEditingController();
  final TextEditingController schoolDomainController = TextEditingController();
  final TextEditingController homeAddressController = TextEditingController();
  final TextEditingController emergencyContactNameController = TextEditingController();
  final TextEditingController emergencyContactPhoneController = TextEditingController();
  final TextEditingController emergencyContactEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> registerTeacher() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    AuthService authService = AuthService();
    var user = await authService.signUpUser(
      emailController.text.trim(),
      passwordController.text.trim(),
      "teacher",
      "",
      schoolDomainController.text.trim(),
    );

    if (user != null) {
      String schoolDomain = schoolDomainController.text.trim();
      String grade = gradeLevelController.text.trim();

      // Save to teachers collection (full profile)
      await FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolDomain)
          .collection('teachers')
          .doc(user.uid)
          .set({
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneNumberController.text.trim(),
        'gradeLevel': grade,
        'school': schoolDomain,
        'homeAddress': homeAddressController.text.trim(),
        'emergencyContactName': emergencyContactNameController.text.trim(),
        'emergencyContactPhone': emergencyContactPhoneController.text.trim(),
        'emergencyContactEmail': emergencyContactEmailController.text.trim(),
        'role': "teacher",
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add to classes collection (summary)
      await FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolDomain)
          .collection('classes')
          .doc(grade)
          .collection('teachers')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneNumberController.text.trim(),
        'grade': grade,
        'schoolDomain': schoolDomain,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Teacher Registered Successfully!")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign-up failed")));
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
            TextField(controller: phoneNumberController, decoration: InputDecoration(labelText: "Phone Number")),
            TextField(
              controller: gradeLevelController,
              decoration: InputDecoration(
                labelText: "What grade level do you teach?",
                hintText: "e.g. Kindergarten, Grade 1, Grade 2",
              ),
            ),
            TextField(
              controller: schoolDomainController,
              decoration: InputDecoration(
                labelText: "School Domain",
                hintText: "e.g. chicoelementary.edu",
              ),
            ),
            TextField(controller: homeAddressController, decoration: InputDecoration(labelText: "Home Address")),
            SizedBox(height: 20),
            Text("📞 Emergency Contact", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: emergencyContactNameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: emergencyContactPhoneController, decoration: InputDecoration(labelText: "Phone")),
            TextField(controller: emergencyContactEmailController, decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 20),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: "Confirm Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: registerTeacher, child: Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}
