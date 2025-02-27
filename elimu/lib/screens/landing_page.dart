import 'package:flutter/material.dart';
import 'login_student.dart';
import 'login_teacher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<bool> _isHovering = [false, false];

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
                  'ELIMU',
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
                    _buildNavItem(1, "Login"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // Full-screen backgroung image
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

          // login
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
                        "Welcome to Elimu 🎓",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildRoleButton(context, "Student"),
                      SizedBox(height: 15),
                      _buildRoleButton(context, "Teacher"),
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

  //Navogation
  Widget _buildNavItem(int index, String title) {
    return InkWell(
      onHover: (value) {
        setState(() {
          _isHovering[index] = value;
        });
      },
      onTap: () {
        // Handle navigation
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: _isHovering[index] ? Colors.blue.shade200 : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Visibility(
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            visible: _isHovering[index],
            child: Container(
              height: 2,
              width: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Login role buttons
  Widget _buildRoleButton(BuildContext context, String role) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => role == "Student" ? LoginStudentPage() : LoginTeacherPage(),
            ),
          );
        },
        child: Text(
          "Login as $role",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
