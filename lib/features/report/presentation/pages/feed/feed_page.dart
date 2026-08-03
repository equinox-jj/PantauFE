import 'package:flutter/material.dart';

import '../../../../../core/components/empty_state/empty_state.dart';

/// Feed tab — nearby reports as a photo-led list.
///
/// Placeholder until the report list slice lands (Phase 3).
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: const SafeArea(
        child: AppEmptyState(
          icon: Icons.subject_outlined,
          title: 'Nothing in the feed yet',
          message: 'Reports from your area will show up here as they come in.',
        ),
      ),
    );
  }
}
