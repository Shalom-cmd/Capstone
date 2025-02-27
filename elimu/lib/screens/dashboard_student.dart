import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  final String fullName; // Receive student name from login

  const StudentDashboard({Key? key, required this.fullName}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool isMusicOn = false; // Background music toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSidebar(),
      appBar: AppBar(
        title: Text("Welcome back, ${widget.fullName}! 🎉"),// Display student name.
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {}, // Handle notifications
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {}, // Open profile/settings
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickSummaryCard(),
            SizedBox(height: 20),
            _buildMyClasses(),
            SizedBox(height: 20),
            _buildAssignmentsOverview(),
            SizedBox(height: 20),
            _buildLearningProgressBar(),
            SizedBox(height: 20),
            _buildFunExtras(),
          ],
        ),
      ),
    );
  }

  // Sidebar Navigation
  Widget _buildSidebar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("📚 ELIMU Dashboard", style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
          _buildSidebarItem(Icons.home, "Home 🏠"),
          _buildSidebarItem(Icons.book, "My Classes 📚"),
          _buildSidebarItem(Icons.assignment, "My Assignments 📝"),
          _buildSidebarItem(Icons.quiz, "Quizzes & Tests 🏆"),
          _buildSidebarItem(Icons.message, "Messages ✉️"),
          _buildSidebarItem(Icons.leaderboard, "Leaderboard 🎖️"),
          _buildSidebarItem(Icons.card_giftcard, "Rewards & Badges 🏅"),
          _buildSidebarItem(Icons.settings, "Settings ⚙️"),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () {}, // Handle navigation
    );
  }

  // Quick Summary Card
  Widget _buildQuickSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📅 Next Class: Math with Mr. Smith @ 10:00 AM", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("📢 Announcements: Science project due Friday!", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("🔥 Streaks: You've completed 5 assignments in a row!", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  // My Classes Section
  Widget _buildMyClasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📚 My Classes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildClassCard("Math", "Mr. Smith", 0.8),
            _buildClassCard("Science", "Ms. Johnson", 0.6),
            _buildClassCard("History", "Mr. Brown", 0.5),
            _buildClassCard("English", "Ms. Lee", 0.9),
          ],
        ),
      ],
    );
  }

  Widget _buildClassCard(String subject, String teacher, double progress) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📖 $subject", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("👨‍🏫 $teacher", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300]),
            SizedBox(height: 5),
            Text("Progress: ${(progress * 100).toInt()}%"),
          ],
        ),
      ),
    );
  }

  // Assignments Overview
  Widget _buildAssignmentsOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📝 Assignments & Homework", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        _buildAssignmentCard("Math Homework", "Due: Tomorrow"),
        _buildAssignmentCard("Science Project", "Due: Friday"),
        _buildAssignmentCard("History Essay", "Due: Next Monday"),
      ],
    );
  }

  Widget _buildAssignmentCard(String title, String dueDate) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(dueDate, style: TextStyle(color: Colors.red)),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {}, // Navigate to assignment details
      ),
    );
  }

  // Learning Progress Bar
  Widget _buildLearningProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📊 Learning Progress", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        _buildProgressItem("📗 Read 10/20 pages", 0.5),
        _buildProgressItem("💡 Completed 3/5 quizzes", 0.6),
        _buildProgressItem("🎨 Submitted 2/3 creative projects", 0.7),
      ],
    );
  }

  Widget _buildProgressItem(String title, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300]),
        ],
      ),
    );
  }

  // Fun Extras
  Widget _buildFunExtras() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🎉 Fun Extra Activities", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("📜 Quote of the Day: 'Education is the passport to the future.'"),
        SizedBox(height: 10),
        SwitchListTile(
          title: Text("🎵 Background Music"),
          value: isMusicOn,
          onChanged: (bool value) {
            setState(() {
              isMusicOn = value;
            });
          },
        ),
      ],
    );
  }
}

