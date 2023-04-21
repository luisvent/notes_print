import 'dart:io';

import 'package:datecs_printer/method/datecs_device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../models/note.dart';
import '../widgets/android_print_options.dart';

class NotePage extends StatefulWidget {
  static const routeName = '/note-page';
  final Function updateNote;
  final Function addNote;
  final Function removeNote;
  final Function printNote;

  NotePage(this.addNote, this.updateNote, this.removeNote, this.printNote);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Note note;
  var isNewNote = false;
  var isUpdateNote = false;
  List availableBluetoothDevices = [];

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  void goBack(BuildContext context) {
    note.title = _titleController.value.text;
    note.content = _contentController.value.text;

    if (isNewNote) {
      if (_contentController.value.text.isEmpty && _titleController.value.text.isEmpty) {
      } else if (_contentController.value.text.isEmpty && !_titleController.value.text.isEmpty) {
        widget.addNote(note);
      } else if (!_contentController.value.text.isEmpty && _titleController.value.text.isEmpty) {
        note.title = 'New Note ${DateTime.now()}';
        widget.addNote(note);
      } else {
        widget.addNote(note);
      }
    } else {
      widget.updateNote(note);
    }

    Navigator.of(context).pop();
  }

  initNote(Note noteToInit) {
    isUpdateNote = true;
    setState(() {
      _titleController.text = noteToInit!.title;
      _contentController.text = noteToInit!.content;
      note = noteToInit;
    });
  }

  newNote() {
    isNewNote = true;
    note = Note();
  }

  closeAndRemove() {
    widget.removeNote(note);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
    });

    return Future.value(status);
  }

  void printNote(Note note) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      var doc = pw.Document();

      doc.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) {
            return pw.Column(
              children: [pw.Text(note.title, style: pw.TextStyle(fontSize: 18)), pw.SizedBox(height: 20), pw.Text(note.content, style: pw.TextStyle(fontSize: 14))],
            );
          },
        ),
      );

      return doc.save();
    });
  }

  List<DropdownMenuItem<DatecsDevice>> _getDeviceItems() {
    List<DropdownMenuItem<DatecsDevice>> items = [];
    if (availableBluetoothDevices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      for (var device in availableBluetoothDevices) {
        items.add(DropdownMenuItem(
          child: Text(device.name, overflow: TextOverflow.ellipsis),
          value: DatecsDevice(device.name, device.address),
        ));
      }
    }

    print(items);
    return items;
  }

  openRemoveDialog(BuildContext context, String title, String text) async {
    await Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(text),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    closeAndRemove();
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text(title),
              content: new Text(text),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: new Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    closeAndRemove();
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments;
    DatecsDevice _device = DatecsDevice('None', 'none');
    var printerSelected = 'none';

    if (data == null) {
      newNote();
    } else {
      initNote(data as Note);
    }

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => goBack(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: Theme.of(context).primaryColor,
                            )),
                        Container(
                          width: 270,
                          child: TextField(
                            controller: _titleController,
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Merriweather',
                              color: Theme.of(context).primaryColor,
                            ),
                            decoration: InputDecoration(hintText: 'Title...', focusedBorder: InputBorder.none, enabledBorder: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        isNewNote
                            ? Container()
                            : IconButton(
                                onPressed: () {
                                  openRemoveDialog(context, 'Are you sure?', 'Do you want to delete this note?');
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                ))
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 400,
                  child: TextField(
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Handlee',
                      color: Theme.of(context).primaryColor,
                    ),
                    controller: _contentController,
                    maxLines: 90,
                    decoration: InputDecoration(
                      hintText: 'Note...',
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsetsDirectional.only(start: 10.0),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(237, 222, 199, 8),
                      Color.fromRGBO(237, 222, 199, 0.7),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(237, 222, 199, 0.6),
                      Color.fromRGBO(237, 222, 199, 0.6),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                Share.share('${_titleController.value.text}: ${_contentController.value.text}', subject: 'Note shared from NotesPrint');
                              },
                              icon: Icon(
                                Icons.ios_share,
                                color: Theme.of(context).primaryColor,
                              )),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: '${_titleController.value.text}: ${_contentController.value.text}'));
                                var snackBar = const SnackBar(content: Text('Copied to clipboard!'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Theme.of(context).primaryColor,
                              )),
                          IconButton(
                              onPressed: Platform.isIOS
                                  ? () {
                                      printNote(note);
                                    }
                                  : () {
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) => AndroidPrintOptions(note),
                                      );

                                      // widget.printNote(note);

                                      // requestPermission(Permission.bluetoothConnect).then((value) {
                                      //   if (value.isGranted) {
                                      //     final printController = Printer();
                                      //     printController.GetBluetoothList().then((value) {
                                      //       setState(() {
                                      //         availableBluetoothDevices = value;
                                      //       });
                                      //     });
                                      //   }
                                      // });
                                    },
                              icon: Icon(
                                Icons.print,
                                color: Theme.of(context).primaryColor,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: availableBluetoothDevices
                      .map(
                        (device) => OutlinedButton(
                            onPressed: () {
                              // var printerController = Printer();
                              // printerController.Connect(device).then((value) {
                              //   printerController.getTestTicketDatecs().then((ticket) => printerController.Print(ticket));
                              // });
                            },
                            child: Text(device.name)),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
