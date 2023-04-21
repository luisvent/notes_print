import 'package:flutter/material.dart';
import 'package:notes_print/pages/about_page.dart';
import 'package:notes_print/widgets/note_item.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/note.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';
  List<Note> notesList = [];
  var bluetoothPermissionGranted = true;

  HomePage(this.notesList) {}

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  createNewNote(BuildContext context) {
    Navigator.of(context).pushNamed(NotePage.routeName, arguments: null);
  }

  @override
  Widget build(BuildContext context) {
    Permission.bluetoothConnect.isGranted.then((bluetoothPermissionStatus) {
      setState(() {
        widget.bluetoothPermissionGranted = bluetoothPermissionStatus;
      });
    });

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        color: Color.fromRGBO(163, 152, 118, 1),
                        onPressed: () {
                          Navigator.of(context).pushNamed(AboutPage.routeName);
                        },
                      ),
                      Text(
                        'Notes',
                        style: TextStyle(fontSize: 40, fontFamily: 'Dosis', color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () => createNewNote(context),
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: widget.notesList.length == 0
                    ? Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.sticky_note_2_outlined, size: 28, color: Color.fromRGBO(163, 152, 118, 1)),
                              Text(
                                'No notes created yet',
                                style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1)),
                              )
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: GridView(
                              children: widget.notesList.map((note) => NoteItem(note)).toList(),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 1,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                final status = await Permission.bluetoothConnect.request();

                                if (status.isGranted) {
                                  var snackBar = const SnackBar(content: Text('Permission Granted!'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                  setState(() {
                                    widget.bluetoothPermissionGranted = true;
                                  });
                                }
                              },
                              child: widget.bluetoothPermissionGranted
                                  ? Container()
                                  : Text(
                                      'No bluetooth permission granted',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromRGBO(163, 152, 118, 0.6),
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
