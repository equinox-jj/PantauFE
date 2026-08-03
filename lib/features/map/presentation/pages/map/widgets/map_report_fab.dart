import 'package:flutter/material.dart';

/// Primary action of the map tab: start a new report.
class MapReportFab extends StatelessWidget {
  const MapReportFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.add_a_photo_outlined),
      label: const Text('Report'),
    );
  }
}
