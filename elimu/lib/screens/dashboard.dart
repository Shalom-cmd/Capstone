import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final String role;

  DashboardPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$role Dashboard')),
      body: Center(
        child: Text(
          "Welcome to $role Dashboard",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
