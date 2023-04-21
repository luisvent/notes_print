import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Print extends StatefulWidget {
  List<String> ticketToPrint = [];
  var title = '';
  var content = '';

  Print({this.title = '', this.content = ''});

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title, String content) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [pw.Text(title, style: pw.TextStyle(fontSize: 18)), pw.SizedBox(height: 20), pw.Text(content, style: pw.TextStyle(fontSize: 14))],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) => _generatePdf(format, widget.title, widget.content),
    );
  }
}
