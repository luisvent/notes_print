import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about-page';

  const AboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 0.8,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {Navigator.of(context).pop()},
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
                          )),
                      Container(
                        width: 270,
                        child: Text('About',
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Merriweather',
                              color: Theme.of(context).primaryColor,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.code_off, size: 28, color: Color.fromRGBO(163, 152, 118, 1)),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            child: Column(
                          children: const [
                            Text(
                              'NotesPrint',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Created By: Luis Ventura',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1)),
                            ),
                            Text(
                              'https://github.com/luisvent/notes_print',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Simple app built to TEST bluetooth thermal printing on ANDROID',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Support creating new notes, share, copy to clipboard, download, classic printing and bluetooth thermal printing only on Android',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Credits:',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'https://github.com/rezins/datecs_printer',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1), fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'https://github.com/DavBfr/dart_pdf',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1), fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/share_plus',
                              style: TextStyle(color: Color.fromRGBO(163, 152, 118, 1), fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
