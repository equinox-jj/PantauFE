import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/theme.dart';
import '../../../auth/di/di.dart';
import '../../../auth/domain/entity/entity.dart';

/// Avatar, name, email and join date of the signed-in user.
class ProfileIdentityCard extends ConsumerWidget {
  const ProfileIdentityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return switch (currentUser) {
      AsyncError() => _ProfileIdentityError(
        onRetry: () => ref.invalidate(currentUserProvider),
      ),
      AsyncData(value: final user) => _ProfileIdentityContent(
        user: user ?? const CurrentUser(),
      ),
      _ => const Skeletonizer(
        child: _ProfileIdentityContent(
          user: CurrentUser(
            username: 'Loading name',
            email: 'loading@email.com',
          ),
        ),
      ),
    };
  }
}

class _ProfileIdentityContent extends StatelessWidget {
  const _ProfileIdentityContent({required this.user});

  final CurrentUser user;

  static const _avatarSize = 56.0;

  String? get _name => user.displayName ?? user.username;

  String get _initials {
    final name = _name?.trim();
    if (name == null || name.isEmpty) return '';

    final parts = name.split(RegExp(r'\s+'));
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';

    return '$first$last'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final joined = user.createdAt != null
        ? 'Joined ${DateFormat('MMM yyyy').format(user.createdAt!)}'
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: AppColors.borderHairline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 3,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            _Avatar(initials: _initials, size: _avatarSize),
            const Gap(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _name ?? user.email ?? 'Citizen',
                    style: AppTypography.subheading,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user.email != null) ...[
                    const Gap(2),
                    Text(
                      user.email!,
                      style: AppTypography.body.copyWith(fontSize: 12.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (joined != null) ...[
                    const Gap(4),
                    Text(joined, style: AppTypography.mono(fontSize: 11)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(AppColors.accent, Colors.white, 0.35)!,
            AppColors.accent,
          ],
        ),
      ),
      child: initials.isEmpty
          ? const Icon(Icons.person, color: AppColors.onAccent)
          : Text(
              initials,
              style: TextStyle(
                fontSize: size * 0.34,
                fontWeight: FontWeight.w800,
                color: AppColors.onAccent,
              ),
            ),
    );
  }
}

class _ProfileIdentityError extends StatelessWidget {
  const _ProfileIdentityError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: AppColors.borderHairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(Icons.person_off_outlined, color: AppColors.textMuted),
            const Gap(AppSpacing.sm),
            Expanded(
              child: Text(
                'Could not load your profile',
                style: AppTypography.body,
              ),
            ),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
