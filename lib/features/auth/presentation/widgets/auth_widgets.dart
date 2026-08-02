import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/extensions/extensions.dart';

/// Screen title + subtitle used at the top of the login and register pages.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.xs2),
        Text(subtitle, style: context.textTheme.bodyLarge),
      ],
    );
  }
}

/// "Don't have an account? Sign up" style row linking between auth pages.
class AuthFooterPrompt extends StatelessWidget {
  const AuthFooterPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onPressed,
  });

  final String promptText;
  final String actionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(promptText, style: context.textTheme.bodyMedium),
        TextButton(onPressed: onPressed, child: Text(actionText)),
      ],
    );
  }
}
