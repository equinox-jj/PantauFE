import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/components/button/button.dart';
import '../../../../../../core/theme/theme.dart';
import '../provider/provider.dart';

/// Copy and optional recovery action for one map status.
typedef _SheetStatus = ({
  IconData icon,
  String title,
  String message,
  Widget? action,
});

/// The compact sheet that explains why the map has no markers: a failed load,
/// a filter that matched nothing, or an area nobody has reported in.
///
/// It is not a modal — the map stays pannable underneath, which is the way
/// out of all three states. It owns its own subscriptions, so a reports
/// change repaints this sheet alone and never the map.
///
/// Sizing is left to the sheet: it is the last child of the bottom-anchored
/// column in `MapPage`, so growing it lifts the locate button and the report
/// FAB instead of hiding behind them.
class MapStatusSheet extends StatelessWidget {
  const MapStatusSheet({super.key, required this.onRetry});

  final VoidCallback onRetry;

  /// The status worth showing, or null when the markers on screen speak for
  /// themselves (or a load is still in flight and might yet produce some).
  _SheetStatus? _statusFor(WidgetRef ref) {
    final reports = ref.watch(filteredReportsProvider);
    if (reports.isNotEmpty) return null;

    final reportsState = ref.watch(nearbyReportsProvider);

    if (reportsState.hasError) {
      return (
        icon: Icons.cloud_off,
        title: 'Could not load reports',
        message: 'Check your connection and try again.',
        action: AppButton(
          text: 'Try again',
          fullWidth: false,
          onPressed: onRetry,
        ),
      );
    }

    // A category filter that matched nothing is not an empty area: the map may
    // still be holding markers of every other category.
    final hasUnfilteredReports = ref.watch(visibleReportsProvider).isNotEmpty;

    if (hasUnfilteredReports) {
      return (
        icon: Icons.filter_alt_off_outlined,
        title: 'No matching reports',
        message:
            'Nothing in this category here. Move the map or clear the '
            'filter.',
        action: AppButton(
          text: 'Show all',
          fullWidth: false,
          variant: AppButtonVariant.secondary,
          onPressed: () => ref.read(mapCategoryFilterProvider.notifier).clear(),
        ),
      );
    }

    if (!reportsState.isLoading) {
      return (
        icon: Icons.map_outlined,
        title: 'No reports nearby',
        message:
            'Nothing reported here yet. Move the map and search there, '
            'or be the first.',
        action: null,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final status = _statusFor(ref);

        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: Alignment.bottomCenter,
          // Zero height rather than [SizedBox.shrink] so the collapse animates
          // downward only and never narrows the column mid-flight.
          child: status == null
              ? const SizedBox(width: double.infinity)
              : _StatusCard(status: status),
        );
      },
    );
  }
}

/// The sheet chrome: rounded top, raised surface, and the icon/copy row.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});

  final _SheetStatus status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surfaceSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        boxShadow: AppShadows.card,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs2,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: _SheetGrabber()),
              const Gap(AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconTile(icon: status.icon),
                  const Gap(AppSpacing.xs),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(status.title, style: AppTypography.subheading),
                        const Gap(AppSpacing.xs2),
                        Text(status.message, style: AppTypography.body),
                      ],
                    ),
                  ),
                ],
              ),
              if (status.action case final action?) ...[
                const Gap(AppSpacing.xs),
                Align(alignment: Alignment.centerRight, child: action),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Accent medallion for the status icon — the empty state's 96px tile cut
/// down to something a sheet this short can carry.
class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.fillAccent,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.borderAccent),
      ),
      child: Icon(icon, size: 16, color: AppColors.accent),
    );
  }
}

/// Decorative handle matching the report detail sheet, so both surfaces read
/// as the same kind of thing.
class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 4,
      decoration: const BoxDecoration(
        color: AppColors.borderDefault,
        borderRadius: AppRadius.radiusFull,
      ),
    );
  }
}
