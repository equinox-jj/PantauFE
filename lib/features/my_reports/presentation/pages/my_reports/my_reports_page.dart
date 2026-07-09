import 'package:flutter/material.dart';

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyReportsUI();
  }
}

class MyReportsUI extends StatefulWidget {
  const MyReportsUI({super.key});

  @override
  State<MyReportsUI> createState() => _MyReportsUIState();
}

class _MyReportsUIState extends State<MyReportsUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("MyReports Page")));
  }
}
