import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_print/pages/note_page.dart';

import '../models/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem(this.note);

  void selectNote(BuildContext context) {
    Navigator.of(context).pushNamed(NotePage.routeName, arguments: this.note);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.brown,
      borderRadius: BorderRadius.circular(18),
      onTap: () => selectNote(context),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(237, 222, 199, 8),
            Color.fromRGBO(237, 222, 199, 0.7),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '${note.title}',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Merriweather',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  note.content.length > 110 ? '${note.content}'.substring(0, 110) + '...' : '${note.content}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Handlee',
                    color: Color.fromRGBO(163, 152, 118, 1),
                  ),
                  // style: TextStyle(fontSize: 11, fontFamily: 'Fasthand', color: Color.fromRGBO(163, 152, 118, 1)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(163, 152, 118, 0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: Text(
                        '${DateFormat.yMd().format(DateTime.parse(note.creationDate))}',
                        style: TextStyle(fontSize: 11, fontFamily: 'Merriweather', color: Theme.of(context).primaryColor),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
