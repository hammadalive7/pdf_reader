import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdf_reader/UI/pdf_view.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class PdfReaderScreen extends StatefulWidget {
  @override
  _PdfReaderScreenState createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  String _pdfPath = '';

  List<String> _recentPdfs = [];

  List<String> _filteredRecentPdfs = [];

  @override
  void initState() {
    super.initState();
    _loadRecentPdfs();
  }

  Future<void> _loadRecentPdfs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentPdfs = prefs.getStringList('recent_pdfs') ?? [];
    setState(() {
      _recentPdfs = recentPdfs;
      _filteredRecentPdfs = recentPdfs;
    });
  }

  Future<void> _openPdfPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfPath = result.files.single.path!;
        _saveRecentPdf(_pdfPath);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfViewerScreen(pdfPath: _pdfPath)),
      );
    }
  }

  Future<void> _saveRecentPdf(String pdfPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentPdfs = prefs.getStringList('recent_pdfs') ?? [];

    // Remove the PDF path from the list if it already exists
    recentPdfs.remove(pdfPath);

    // Add the PDF path to the beginning of the list
    recentPdfs.insert(0, pdfPath);

    // Keep only the latest 10 PDF paths
    if (recentPdfs.length > 10) {
      recentPdfs = recentPdfs.sublist(0, 10);
    }

    // Save the list of PDF paths to SharedPreferences
    await prefs.setStringList('recent_pdfs', recentPdfs);
    setState(() {
      _recentPdfs = recentPdfs;
      _filteredRecentPdfs = recentPdfs;
    });
  }

  void _searchPdf(String query) {
    List<String> filteredPdfs = _recentPdfs
        .where((pdfPath) =>
            path.basename(pdfPath).toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredRecentPdfs = filteredPdfs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Reader Pro'),
        actions: [
          IconButton(
            icon: Icon(Icons.folder_special_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          SizedBox(width: 3),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(58),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Document',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                _searchPdf(query);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.0),
            Text(
              'Recently Viewed',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            if (_filteredRecentPdfs.isNotEmpty)
              Container(
                height: MediaQuery.of(context).size.height - 56 - 48 - 80,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _filteredRecentPdfs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String pdfPath = _filteredRecentPdfs[index];
                    String pdfName = path.basename(pdfPath);
                    return ListTile(
                      leading: Image.asset(
                        'assets/images/pdf-file.png',
                        height: 24,
                        width: 24,
                      ),
                      title: Text(pdfName),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PdfViewerScreen(pdfPath: pdfPath)),
                        );
                      },
                    );
                  },
                ),
              ),
            if (_filteredRecentPdfs.isEmpty)
              Container(
                height: MediaQuery.of(context).size.height - 56 - 48 - 80,
                child: Center(
                  child: Text(
                    'No PDFs found.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPdfPicker,
        child: Icon(Icons.folder),
      ),
    );
  }
}
