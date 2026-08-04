import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../core/components/button/button.dart';
import '../../../../../core/error/error.dart';
import '../../../../../core/theme/theme.dart';
import '../../../domain/entity/entity.dart';
import 'provider/provider.dart';
import 'widgets/widgets.dart';

/// Bottom sheet showing one report: photo, status, category, description,
/// coordinates and timestamps. The chrome is built once; only the body swaps
/// between the loading, error and content states.
class ReportDetailSheet extends StatelessWidget {
  const ReportDetailSheet({super.key, required this.reportId});

  final String reportId;

  /// Presents the sheet over the map.
  static Future<void> show(BuildContext context, {required String reportId}) {
    return showModalBottomSheet<void>(
      context: context,
      // The map tab lives in the dashboard shell's IndexedStack; without the
      // root navigator the barrier scopes to the branch navigator, leaving the
      // bottom nav bar uncovered and the sheet double-padded.
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => ReportDetailSheet(reportId: reportId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(reportDetailProvider(reportId));

            return switch (state) {
              AsyncLoading() => const _SheetLoading(),
              AsyncError(error: final error) => _SheetError(
                message: error is Failure
                    ? error.displayMessage
                    : error.toString(),
                onRetry: () => ref.invalidate(reportDetailProvider(reportId)),
              ),
              AsyncValue(value: final detail?) => _SheetContent(detail: detail),
            };
          },
        ),
      ),
    );
  }
}

class _SheetLoading extends StatelessWidget {
  const _SheetLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SheetGrabber(),
        const Gap(AppSpacing.lg),
        Container(
          height: 180,
          decoration: const BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: AppRadius.radiusXl,
          ),
        ),
        const Gap(AppSpacing.lg),
        const CircularProgressIndicator(),
        const Gap(AppSpacing.lg),
      ],
    );
  }
}

class _SheetError extends StatelessWidget {
  const _SheetError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SheetGrabber(),
        const Gap(AppSpacing.lg),
        Text(message, textAlign: TextAlign.center, style: AppTypography.body),
        const Gap(AppSpacing.lg),
        AppButton(text: 'Try again', fullWidth: false, onPressed: onRetry),
      ],
    );
  }
}

class _SheetContent extends StatelessWidget {
  const _SheetContent({required this.detail});

  final ReportDetail detail;

  static final _dateFormat = DateFormat('d MMM yyyy · HH:mm');

  String _formatDate(DateTime? value) =>
      value == null ? '—' : _dateFormat.format(value.toLocal());

  String get _coordinates {
    final latitude = detail.latitude;
    final longitude = detail.longitude;
    if (latitude == null || longitude == null) return '—';

    return '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: _SheetGrabber()),
          const Gap(AppSpacing.lg),
          ReportDetailPhoto(photoUrl: detail.photoUrl),
          const Gap(AppSpacing.lg),
          ReportStatusChip(status: detail.status),
          const Gap(AppSpacing.md),
          Text(
            detail.category?.name ?? 'Uncategorised',
            style: AppTypography.title.copyWith(fontSize: 22),
          ),
          if ((detail.description ?? '').isNotEmpty) ...[
            const Gap(AppSpacing.xs2),
            Text(detail.description!, style: AppTypography.bodyLarge),
          ],
          const Gap(AppSpacing.lg),
          ReportDetailRow(
            icon: Icons.place_outlined,
            label: 'Coordinates',
            value: _coordinates,
            isMono: true,
          ),
          const Gap(AppSpacing.md),
          ReportDetailRow(
            icon: Icons.schedule,
            label: 'Reported',
            value: _formatDate(detail.createdAt),
          ),
          const Gap(AppSpacing.md),
          ReportDetailRow(
            icon: Icons.update,
            label: 'Last updated',
            value: _formatDate(detail.updatedAt),
          ),
          const Gap(AppSpacing.lg),
        ],
      ),
    );
  }
}

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
