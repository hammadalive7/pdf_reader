import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;

  PdfViewerScreen({required this.pdfPath});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}


class _PdfViewerScreenState extends State<PdfViewerScreen> {

  void _closePdf() {
    Navigator.pop(context);
  }

  void _editPdf() {
    // Edit PDF
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Reader Pro'),
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_rounded, size: 35,),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.content_paste_search_rounded),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
            },
          ),
          SizedBox(width: 3),
        ],

      ),
      body: SfPdfViewer.file(
        File(widget.pdfPath),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          FloatingActionButton(
            onPressed: () {},
            tooltip: "Favorite",
            child: Icon(Icons.folder_special_rounded),
          ),
          SizedBox(width: 1),
          FloatingActionButton(
            onPressed: () {},
            tooltip: "Fullscreen",
            child: Icon(Icons.zoom_out_map),
          ),

          SizedBox(width: 1),
          FloatingActionButton(
            onPressed: _closePdf,
            tooltip: 'Close PDF',
            child: Icon(Icons.outbox_rounded),

          ),
          SizedBox(width: 1),
          FloatingActionButton(
            onPressed: _editPdf,
            tooltip: 'Edit PDF',
            child: Icon(Icons.edit),
          ),

        ],
      ),
    );
  }
}