import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/components/button/button.dart';
import '../../../../../core/components/empty_state/empty_state.dart';
import '../../../../../core/error/error.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/service/service.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../../../map/presentation/pages/report_detail/report_detail.dart';
import '../../../domain/entity/entity.dart';
import 'listener/listener.dart';
import 'provider/provider.dart';
import 'widgets/feed_widgets.dart';

/// Feed tab — the reports around the device as a photo-led list.
///
/// The device position is the query, so locating is also the fetch trigger:
/// there is no camera to pan and nothing to show without a fix.
class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedLocationProvider.notifier).locate();
    });
  }

  void _handleLocated(LocationResult result) {
    if (result is! LocationSuccess) return;

    ref
        .read(feedReportsProvider.notifier)
        .load(latitude: result.latitude, longitude: result.longitude);
  }

  /// Refetches around the position already used. Cheaper than re-locating,
  /// which is what the location-error state's action is for.
  Future<void> _refresh() => ref.read(feedReportsProvider.notifier).refresh();

  void _locate() => ref.read(feedLocationProvider.notifier).locate();

  void _openSettings() =>
      ref.read(feedLocationProvider.notifier).openSettings();

  void _openReport(FeedReport report) {
    final id = report.id;
    if (id == null) return;

    ReportDetailSheet.show(context, reportId: id);
  }

  void _startReport() => context.push(AppRoutes.createReport);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeedListener(
        onLocated: _handleLocated,
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _refresh,
            backgroundColor: AppColors.surfaceRaised,
            color: AppColors.accent,
            child: CustomScrollView(
              // Every state must stay pullable, including the empty ones.
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: _FeedHeader()),
                _FeedBody(
                  onReportTap: _openReport,
                  onRetry: _refresh,
                  onLocate: _locate,
                  onOpenSettings: _openSettings,
                  onStartReport: _startReport,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Screen title and the line describing what the list covers.
class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Feed', style: AppTypography.title.copyWith(fontSize: 24)),
          const Gap(4),
          const _FeedSubtitle(),
        ],
      ),
    );
  }
}

/// Report count and radius. Subscribes on its own so a fetch repaints this
/// line alone, not the whole header.
class _FeedSubtitle extends StatelessWidget {
  const _FeedSubtitle();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final items = ref.watch(
          feedReportsProvider.select((state) => state.value),
        );
        final radius = formatDistance(kFeedRadiusInMeters.toDouble());
        final count = items == null
            ? 'Around you'
            : '${items.length} ${items.length == 1 ? 'report' : 'reports'}';

        return Text(
          '$count · $radius radius',
          style: AppTypography.mono(fontSize: 11, color: AppColors.textMuted),
        );
      },
    );
  }
}

/// The list and every state that replaces it: location refused, fetch failed,
/// first load, and nothing reported nearby.
class _FeedBody extends StatelessWidget {
  const _FeedBody({
    required this.onReportTap,
    required this.onRetry,
    required this.onLocate,
    required this.onOpenSettings,
    required this.onStartReport,
  });

  final ValueChanged<FeedReport> onReportTap;
  final VoidCallback onRetry;
  final VoidCallback onLocate;
  final VoidCallback onOpenSettings;
  final VoidCallback onStartReport;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        // Location first: without a fix there is no query, so its outcome
        // outranks whatever the reports state still holds.
        final locationResult = ref.watch(
          feedLocationProvider.select((state) => state.value),
        );
        if (locationResult != null && locationResult is! LocationSuccess) {
          return _FeedStateSliver(
            child: _FeedLocationState(
              result: locationResult,
              onRetry: onLocate,
              onOpenSettings: onOpenSettings,
            ),
          );
        }

        final reports = ref.watch(feedReportsProvider);

        return switch (reports) {
          AsyncError(error: final error) => _FeedStateSliver(
            child: AppEmptyState(
              icon: Icons.cloud_off,
              title: 'Could not load the feed',
              message: error is Failure
                  ? error.displayMessage
                  : 'Check your connection and try again.',
              action: AppButton(
                text: 'Try again',
                fullWidth: false,
                onPressed: onRetry,
              ),
            ),
          ),
          // A refetch keeps the previous cards; only a first load has nothing
          // to show and falls back to skeletons.
          AsyncValue(isLoading: true, value: null) => const _FeedSkeletonList(),
          AsyncValue(value: final items?) when items.isEmpty =>
            _FeedStateSliver(
              child: AppEmptyState(
                icon: Icons.subject_outlined,
                title: 'Nothing reported nearby',
                message:
                    'No reports within '
                    '${formatDistance(kFeedRadiusInMeters.toDouble())} of you '
                    'yet. Be the first to flag something.',
                action: AppButton(
                  text: 'Report an issue',
                  fullWidth: false,
                  onPressed: onStartReport,
                ),
              ),
            ),
          AsyncValue(value: final items?) => _FeedList(
            items: items,
            onReportTap: onReportTap,
          ),
          _ => const _FeedSkeletonList(),
        };
      },
    );
  }
}

class _FeedList extends StatelessWidget {
  const _FeedList({required this.items, required this.onReportTap});

  final List<FeedItem> items;
  final ValueChanged<FeedReport> onReportTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs2,
        AppSpacing.lg,
        AppSpacing.xl2,
      ),
      sliver: SliverList.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => const Gap(AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = items[index];

          return FeedReportCard(
            item: item,
            onTap: () => onReportTap(item.report),
          );
        },
      ),
    );
  }
}

class _FeedSkeletonList extends StatelessWidget {
  const _FeedSkeletonList();

  /// Enough to fill a phone screen; the rest arrives before it is scrolled to.
  static const _placeholderCount = 3;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs2,
        AppSpacing.lg,
        AppSpacing.xl2,
      ),
      sliver: SliverList.separated(
        itemCount: _placeholderCount,
        separatorBuilder: (context, index) => const Gap(AppSpacing.sm),
        itemBuilder: (context, index) => const FeedSkeletonCard(),
      ),
    );
  }
}

/// Wraps a full-screen state so it centres in the remaining viewport while
/// staying inside the pull-to-refresh scroll view.
class _FeedStateSliver extends StatelessWidget {
  const _FeedStateSliver({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl2),
        child: child,
      ),
    );
  }
}

/// Explains why the feed has no position to query with, and offers the
/// recovery that matches the outcome.
class _FeedLocationState extends StatelessWidget {
  const _FeedLocationState({
    required this.result,
    required this.onRetry,
    required this.onOpenSettings,
  });

  final LocationResult result;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final (:title, :message, :actionText, :onAction) = switch (result) {
      LocationPermissionDeniedForever() => (
        title: 'Location is switched off',
        message:
            'The feed lists what has been reported around you. Enable '
            'location access to see it.',
        actionText: 'Open settings',
        onAction: onOpenSettings,
      ),
      LocationPermissionDenied() => (
        title: 'Location permission needed',
        message: 'Pantau needs your location to list reports around you.',
        actionText: 'Try again',
        onAction: onRetry,
      ),
      LocationServiceDisabled() => (
        title: 'Location services are off',
        message:
            'Turn on location services in your device settings to see '
            'reports around you.',
        actionText: 'Try again',
        onAction: onRetry,
      ),
      // LocationFailed; LocationSuccess never reaches this widget.
      _ => (
        title: 'Could not get your location',
        message: LocationFailed.message,
        actionText: 'Try again',
        onAction: onRetry,
      ),
    };

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
