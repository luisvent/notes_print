import 'package:flutter/material.dart';
import 'package:notes_print/models/printer.dart';
import 'package:notes_print/widgets/print.dart';

import '../models/note.dart';
import 'floating_modal.dart';

class AndroidPrintOptions extends StatelessWidget {
  final Note note;

  const AndroidPrintOptions(this.note);

  Future<void> printo() async {
    final printerController = Printer();
    final printResult = await printerController.Print('DPP-250', note.content);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Bluetooth Thermal Printer'),
            leading: Icon(Icons.settings_bluetooth_rounded),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Looking for devices...'),
                duration: Duration(microseconds: 1000),
              ));
              printo();
              // Navigator.of(context).pop();
            },
          ),
          ListTile(
              title: Text('Classic Print'),
              leading: Icon(Icons.print),
              onTap: () {
                Navigator.of(context).pop();
                showFloatingModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 500,
                      width: 50,
                      child: Print(
                        title: note.title,
                        content: note.content,
                      ),
                    );
                  },
                );
              }),
        ],
      ),
    ));
  }
}
