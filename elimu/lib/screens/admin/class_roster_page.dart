import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassRosterPage extends StatefulWidget {
  final String schoolDomain;

  const ClassRosterPage({super.key, required this.schoolDomain});

  @override
  State<ClassRosterPage> createState() => _ClassRosterPageState();
}

class _ClassRosterPageState extends State<ClassRosterPage> {
  late Future<List<String>> classListFuture;

  @override
  void initState() {
    super.initState();
    classListFuture = fetchClassList();
  }

  Future<List<String>> fetchClassList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('schools')
        .doc(widget.schoolDomain)
        .collection('classes')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<Map<String, dynamic>>> fetchUsersInClass(
      String grade, String userType) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('schools')
        .doc(widget.schoolDomain)
        .collection('classes')
        .doc(grade)
        .collection(userType)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Widget buildUserTile(Map<String, dynamic> userData, String userType) {
    return ListTile(
      leading: Icon(userType == 'students' ? Icons.child_care : Icons.person),
      title: Text(userData['fullName'] ?? 'Unknown'),
      subtitle: Text(userType == 'students'
          ? 'Username: ${userData['username'] ?? 'N/A'}'
          : 'Email: ${userData['email'] ?? 'N/A'}'),
      trailing: userData.containsKey('isApprovedByAdmin')
          ? Switch(
              value: userData['isApprovedByAdmin'],
              onChanged: (value) {
                FirebaseFirestore.instance
                    .collection('schools')
                    .doc(widget.schoolDomain)
                    .collection('classes')
                    .doc(userData['grade'])
                    .collection(userData['role'] == 'student'
                        ? 'students'
                        : 'teachers')
                    .doc(userData['uid'])
                    .update({'isApprovedByAdmin': value});
                setState(() {
                  userData['isApprovedByAdmin'] = value;
                });
              },
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📋 Class Roster")),
      body: FutureBuilder<List<String>>(
        future: classListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No classes found."));
          }

          final classList = snapshot.data!;
          return ListView.builder(
            itemCount: classList.length,
            itemBuilder: (context, index) {
              final grade = classList[index];
              return ExpansionTile(
                title: Text("📚 $grade", style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchUsersInClass(grade, 'teachers'),
                    builder: (context, teacherSnap) {
                      if (teacherSnap.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("👩‍🏫 Teachers", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          ...teacherSnap.data!.map((teacher) => buildUserTile(teacher, 'teachers')),
                        ],
                      );
                    },
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchUsersInClass(grade, 'students'),
                    builder: (context, studentSnap) {
                      if (studentSnap.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("🧒 Students", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          ...studentSnap.data!.map((student) => buildUserTile(student, 'students')),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
