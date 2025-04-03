import 'package:flutter/material.dart';
import 'student/login_student.dart';
import 'teacher/login_teacher.dart';
import 'admin/login_admin.dart'; // Import Admin Login Page
import 'school_registration.dart'; // Import the School Registration Page

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoginVisible = false; // Control the visibility of the login options

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 60),
        child: Container(
          color: Colors.blue[900],
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LOGO
                Text(
                  'ELIMU LMS',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Navigation items
                Row(
                  children: [
                    _buildNavItem(0, "About Us"),
                    SizedBox(width: screenSize.width / 30),
                    _buildRegisterSchoolButton(context), // Register School button in the header
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // Full-screen background image
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/animatedkidss.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Centered content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width / 3),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome to Elimu LMS🎓",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Register School Button
                      _buildRegisterSchoolButton(context),
                      SizedBox(height: 20),
                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoginVisible = !_isLoginVisible; // Toggle login options
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,  // Use backgroundColor instead of primary
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Show login options (Admin, Teacher, Student) based on _isLoginVisible
                      if (_isLoginVisible) ...[
                        _buildRoleButton(context, "Student"),
                        SizedBox(height: 10),
                        _buildRoleButton(context, "Teacher"),
                        SizedBox(height: 10),
                        _buildRoleButton(context, "Admin"),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation items for header (About Us)
  Widget _buildNavItem(int index, String title) {
    return InkWell(
      onHover: (value) {
        setState(() {
          // Update hover effect
        });
      },
      onTap: () {
        // Handle navigation (if required)
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Register School button in the header
  Widget _buildRegisterSchoolButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the School Registration Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SchoolRegistrationPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Register Your School",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Login role buttons (Student, Teacher, Admin)
  Widget _buildRoleButton(BuildContext context, String role) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,  // Use backgroundColor instead of primary
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          // Navigate to the appropriate login page
          if (role == "Student") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginStudentPage()),
            );
          } else if (role == "Teacher") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginTeacherPage()),
            );
          } else if (role == "Admin") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginAdminPage()), // Navigate to Admin Login Page
            );
          }
        },
        child: Text(
          "Login as $role",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
