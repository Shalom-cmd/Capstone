// Add this to lib/screens/teacher/create_quiz_page.dart

import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key? key}) : super(key: key);

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  String schoolDomain = '';
  String grade = '';
  bool createInApp = true;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<Map<String, dynamic>> questions = [];

  String fileName = '';
  Uint8List? fileBytes;
  String fileUrl = '';

  final List<String> subjects = [
    'English Language Arts',
    'Mathematics',
    'Science',
    'History-Social Science',
    'Visual and Performing Arts',
    'Physical Education',
    'Health',
    'World Languages',
  ];
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    fetchTeacherInfo();
  }

  Future<void> fetchTeacherInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final schools = await FirebaseFirestore.instance.collection('schools').get();

    for (var school in schools.docs) {
      final doc = await FirebaseFirestore.instance
          .collection('schools')
          .doc(school.id)
          .collection('teachers')
          .doc(user!.uid)
          .get();

      if (doc.exists) {
        setState(() {
          schoolDomain = school.id;
          grade = doc['gradeLevel'];
        });
        break;
      }
    }
  }

  void pickFileWeb() {
    final uploadInput = html.FileUploadInputElement()..accept = '.pdf,.doc,.docx';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file!);
      reader.onLoadEnd.listen((e) {
        setState(() {
          fileName = file.name;
          fileBytes = reader.result as Uint8List;
        });
      });
    });
  }

  void addMultipleChoiceQuestion() {
    setState(() {
      questions.add({
        'type': 'mcq',
        'question': '',
        'options': List<String>.filled(4, ''),
        'correctIndex': 0,
      });
    });
  }

  void addTextQuestion() {
    setState(() {
      questions.add({
        'type': 'text',
        'question': '',
      });
    });
  }

  Future<String> uploadFileToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance
        .ref('quizzes/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}_$fileName');

    final uploadTask = await storageRef.putData(fileBytes!);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> submitQuiz() async {
    if (titleController.text.trim().isEmpty || selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in required fields.")));
      return;
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (!createInApp && fileBytes != null) {
      fileUrl = await uploadFileToFirebase();
    }

    await FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolDomain)
        .collection('classes')
        .doc(grade)
        .collection('quizzes')
        .add({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'subject': selectedSubject,
      'createdBy': userId,
      'type': createInApp ? 'in-app' : 'file',
      'fileUrl': fileUrl,
      'questions': createInApp ? questions : [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Quiz created!")));
    Navigator.pop(context);
  }

  Widget buildQuestionCard(int index) {
    final q = questions[index];

    if (q['type'] == 'mcq') {
      return Card(
        margin: EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Multiple Choice Question ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(labelText: "Question"),
                onChanged: (val) => q['question'] = val,
              ),
              ...List.generate(4, (i) {
                return Row(
                  children: [
                    Radio<int>(
                      value: i,
                      groupValue: q['correctIndex'],
                      onChanged: (val) => setState(() => q['correctIndex'] = val),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Option ${i + 1}"),
                        onChanged: (val) => q['options'][i] = val,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    } else {
      return Card(
        margin: EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Text Question ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(labelText: "Question"),
                onChanged: (val) => q['question'] = val,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📝 Create Quiz")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedSubject,
              decoration: InputDecoration(labelText: "📘 Subject"),
              items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => selectedSubject = val),
            ),
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Quiz Title")),
            SizedBox(height: 10),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Quiz Description")),
            Divider(height: 30),

            SwitchListTile(
              title: Text("Create Quiz In-App"),
              value: createInApp,
              onChanged: (val) => setState(() => createInApp = val),
            ),

            if (createInApp) ...[
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: addMultipleChoiceQuestion,
                    icon: Icon(Icons.list),
                    label: Text("Add MCQ"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: addTextQuestion,
                    icon: Icon(Icons.short_text),
                    label: Text("Add Text Question"),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ...List.generate(questions.length, buildQuestionCard),
            ],

            if (!createInApp && kIsWeb) ...[
              SizedBox(height: 20),
              Text("📎 Upload Quiz File (PDF/DOC)", style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: pickFileWeb,
                icon: Icon(Icons.upload_file),
                label: Text("Pick File"),
              ),
              if (fileName.isNotEmpty) Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("Selected: $fileName"),
              ),
            ],

            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: submitQuiz,
              icon: Icon(Icons.check),
              label: Text("Post Quiz"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
