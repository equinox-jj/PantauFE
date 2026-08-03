import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/components/button/button.dart';
import '../../../../../core/components/empty_state/empty_state.dart';
import '../../../../../core/theme/theme.dart';
import 'listener/listener.dart';
import 'provider/provider.dart';

/// Profile tab — account, notification and app settings.
///
/// Placeholder until the profile slice lands; sign-out is already wired.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: LogoutListener(
        child: SafeArea(
          child: Column(
            children: [
              const Expanded(
                child: AppEmptyState(
                  icon: Icons.person_outline,
                  title: 'Profile coming soon',
                  message:
                      'Your account details and app settings will live here.',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: AppButton(
                  text: 'Sign out',
                  variant: AppButtonVariant.secondary,
                  leading: const Icon(Icons.logout),
                  onPressed: () => _confirmSignOut(context, ref),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to sign in again to report.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) await ref.read(logoutProvider.notifier).logout();
  }
}
