import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportUI();
  }
}

class ReportUI extends StatefulWidget {
  const ReportUI({super.key});

  @override
  State<ReportUI> createState() => _ReportUIState();
}

class _ReportUIState extends State<ReportUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Report Page")));
  }
}
