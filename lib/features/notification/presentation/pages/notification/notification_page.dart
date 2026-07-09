import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationUI();
  }
}

class NotificationUI extends StatefulWidget {
  const NotificationUI({super.key});

  @override
  State<NotificationUI> createState() => _NotificationUIState();
}

class _NotificationUIState extends State<NotificationUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Notification Page")));
  }
}
