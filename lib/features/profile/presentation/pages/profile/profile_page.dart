import 'package:flutter/material.dart';

import '../../../../../core/components/empty_state/empty_state.dart';

/// Profile tab — account, notification and app settings.
///
/// Placeholder until the profile slice lands.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const SafeArea(
        child: AppEmptyState(
          icon: Icons.person_outline,
          title: 'Profile coming soon',
          message: 'Your account details and app settings will live here.',
        ),
      ),
    );
  }
}
