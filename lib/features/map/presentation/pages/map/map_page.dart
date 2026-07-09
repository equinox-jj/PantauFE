import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapUI();
  }
}

class MapUI extends StatefulWidget {
  const MapUI({super.key});

  @override
  State<MapUI> createState() => _MapUIState();
}

class _MapUIState extends State<MapUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Map Page")));
  }
}
