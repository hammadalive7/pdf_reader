import 'package:flutter/material.dart';

import 'UI/pdf_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        // #CD1D1D as a primary color,
        primarySwatch: Colors.red,

      ),
      home: PdfReaderScreen(),
    );
  }
}
