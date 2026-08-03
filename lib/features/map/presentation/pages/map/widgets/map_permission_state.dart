import 'package:flutter/material.dart';

import '../../../../../../core/components/button/button.dart';
import '../../../../../../core/components/empty_state/empty_state.dart';

/// Shown instead of markers when location access is unavailable, explaining
/// why the app needs it and offering the matching recovery action.
class MapPermissionState extends StatelessWidget {
  const MapPermissionState({
    super.key,
    required this.title,
    required this.message,
    required this.actionText,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.location_off_outlined,
      title: title,
      message: message,
      action: AppButton(
        text: actionText,
        fullWidth: false,
        onPressed: onAction,
      ),
    );
  }
}
