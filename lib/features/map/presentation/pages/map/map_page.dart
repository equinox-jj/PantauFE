import 'package:flutter/material.dart';

import '../../../../../core/components/empty_state/empty_state.dart';

/// Home tab — nearby reports on an OSM map with clustered markers.
///
/// Placeholder until the map + nearby query slice lands (Phase 3).
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: const SafeArea(
        child: AppEmptyState(
          icon: Icons.map_outlined,
          title: 'No reports nearby',
          message:
              'Reports around you will appear here as markers once the map is '
              'wired up.',
        ),
      ),
    );
  }
}
