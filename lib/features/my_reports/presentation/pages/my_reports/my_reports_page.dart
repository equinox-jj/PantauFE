import 'package:flutter/material.dart';

import '../../../../../core/components/empty_state/empty_state.dart';

/// My reports tab — the caller's own submissions with their current status.
///
/// Placeholder until the "My Reports" slice lands (Phase 3).
class MyReportsPage extends StatelessWidget {
  const MyReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My reports')),
      body: const SafeArea(
        child: AppEmptyState(
          icon: Icons.photo_camera_outlined,
          title: 'You have not reported anything',
          message:
              'Every report you submit lands here, with its status from '
              'reported through to resolved.',
        ),
      ),
    );
  }
}
