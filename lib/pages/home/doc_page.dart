import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';

class DocPage extends StatelessWidget {
  const DocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.asset('assets/manual.pdf');
  }
}
