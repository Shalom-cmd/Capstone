import 'package:flutter/material.dart';
import 'class_roster_page.dart'; 

class AdminDashboardPage extends StatelessWidget {
  final String schoolDomain;
  final String adminName;

  const AdminDashboardPage({
    super.key,
    required this.schoolDomain,
    required this.adminName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Add logout logic
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $adminName 👋",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Button to View Class Roster
            ElevatedButton.icon(
              icon: Icon(Icons.school),
              label: Text("View Class Rosters"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClassRosterPage(schoolDomain: schoolDomain),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),

            SizedBox(height: 20),

            // Add more buttons for other sections later (users, reports, etc.)
            ElevatedButton.icon(
              icon: Icon(Icons.settings),
              label: Text("School Settings (Coming Soon)"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Coming soon!")),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
