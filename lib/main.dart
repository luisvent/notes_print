import 'package:flutter/material.dart';
import 'package:notes_print/pages/about_page.dart';
import 'package:notes_print/pages/note_page.dart';

import 'data/data.dart';
import 'models/note.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final notesList = notes;

  addNote(Note noteToAdd) {
    print('add note');
    setState(() {
      notesList.add(noteToAdd);
    });
  }

  removeNote(Note noteToRemove) {
    setState(() {
      notesList.removeWhere((note) => note.id == noteToRemove.id);
    });
  }

  updateNote(Note noteUpdated) {
    setState(() {
      final noteToUpdate = notesList.firstWhere((note) => note.id == noteUpdated.id);
      noteToUpdate.title = noteUpdated.title;
      noteToUpdate.content = noteUpdated.content;
    });
  }

  printNote(Note noteToPrint) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotesPrint',
      theme: ThemeData(scaffoldBackgroundColor: Color.fromRGBO(240, 234, 227, 1), primaryColor: Color.fromRGBO(99, 74, 39, 1)),
      routes: {
        '/': (ctx) => HomePage(notesList),
        NotePage.routeName: (ctx) => NotePage(addNote, updateNote, removeNote, printNote),
        AboutPage.routeName: (ctx) => AboutPage(),
      },
    );
  }
}
