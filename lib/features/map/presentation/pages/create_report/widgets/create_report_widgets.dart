import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/error/error.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/helpers/helpers.dart';
import '../../../../domain/entity/entity.dart';
import '../../../provider/provider.dart';
import '../../location_picker/location_picker.dart';
import '../../location_picker/provider/provider.dart';

/// Camera-or-gallery chooser shown before picking a photo.
class PhotoSourceSheet extends StatelessWidget {
  const PhotoSourceSheet({super.key});

  /// Returns the chosen source, or null when dismissed.
  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surfaceSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => const PhotoSourceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Take a photo'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

/// Choice chips for the category taxonomy, with their own loading and error
/// states.
///
/// Only the chip row subscribes to the taxonomy; the label and validation
/// message around it are built once.
class ReportCategorySelector extends StatelessWidget {
  const ReportCategorySelector({
    super.key,
    required this.selectedId,
    required this.onSelected,
    this.errorText,
  });

  final int? selectedId;
  final ValueChanged<int> onSelected;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTypography.label),
        const Gap(AppSpacing.xs2),
        Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(reportCategoriesProvider);

            return switch (state) {
              AsyncLoading() => const _CategoriesLoading(),
              AsyncError(error: final error) => _CategoriesError(
                message: error is Failure
                    ? error.displayMessage
                    : error.toString(),
                onRetry: () => ref.invalidate(reportCategoriesProvider),
              ),
              AsyncValue<List<ReportCategory>>(value: final categories?) =>
                _CategoryChips(
                  categories: categories,
                  selectedId: selectedId,
                  onSelected: onSelected,
                ),
            };
          },
        ),
        if (errorText != null) ...[
          const Gap(AppSpacing.xs2),
          Text(
            errorText!,
            style: AppTypography.label.copyWith(
              color: AppColors.statusRejected,
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<ReportCategory> categories;
  final int? selectedId;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final chips = categories
        .where((category) => category.id != null)
        .map(
          (category) => ChoiceChip(
            label: Text(category.name ?? '—'),
            selected: category.id == selectedId,
            onSelected: (_) => onSelected(category.id!),
          ),
        )
        .toList();

    return Wrap(
      spacing: AppSpacing.xs2,
      runSpacing: AppSpacing.xs2,
      children: chips,
    );
  }
}

class _CategoriesLoading extends StatelessWidget {
  const _CategoriesLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.xl3,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _CategoriesError extends StatelessWidget {
  const _CategoriesError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(message, style: AppTypography.body)),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

/// Where the report will be filed, as a compact card: the pin is placed on the
/// full-screen picker, never here.
///
/// Shows the device lookup while it runs, an empty prompt when there is no pin
/// yet, and the resolved address once there is one.
class ReportLocationSummary extends StatelessWidget {
  const ReportLocationSummary({
    super.key,
    required this.location,
    required this.isLocating,
    required this.onEdit,
    this.errorText,
  });

  final PickedLocation? location;
  final bool isLocating;

  /// Opens the full-screen picker.
  final VoidCallback onEdit;

  /// Set after a failed validation pass.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final location = this.location;
    final errorText = this.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: AppTypography.label),
        const Gap(AppSpacing.xs2),
        InkWell(
          onTap: onEdit,
          borderRadius: AppRadius.radiusLg,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.fillSubtle,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(
                color: errorText == null
                    ? AppColors.borderHairline
                    : AppColors.statusRejected,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: AppIconSizes.md,
                  color: AppColors.accent,
                ),
                const Gap(AppSpacing.xs2),
                Expanded(
                  child: switch ((isLocating, location)) {
                    (true, _) => Text(
                      'Finding your location…',
                      style: AppTypography.body,
                    ),
                    (false, null) => Text(
                      'Set the report location',
                      style: AppTypography.body,
                    ),
                    (false, final picked?) => _LocationLines(location: picked),
                  },
                ),
                const Gap(AppSpacing.xs2),
                Text(
                  location == null ? 'Set pin' : 'Edit pin',
                  style: AppTypography.label.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const Gap(AppSpacing.xs2),
          Text(
            errorText,
            style: AppTypography.label.copyWith(
              color: AppColors.statusRejected,
            ),
          ),
        ],
      ],
    );
  }
}

/// Address line over the coordinate line, matching the picker's readout.
class _LocationLines extends StatelessWidget {
  const _LocationLines({required this.location});

  final PickedLocation location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer(
          builder: (context, ref, _) {
            final address = ref.watch(
              pinAddressProvider(
                latitude: roundedCoordinate(location.latitude),
                longitude: roundedCoordinate(location.longitude),
              ),
            );

            return Text(
              switch (address) {
                AsyncLoading() => 'Naming this spot…',
                AsyncError() => 'Address unavailable',
                AsyncValue<Place?>(value: final place) =>
                  place?.name ?? 'Unnamed location',
              },
              style: AppTypography.body.copyWith(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        Text(
          formatCoordinates(location.latitude, location.longitude),
          style: AppTypography.mono(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// Photo slot of the compose form: empty prompt, or the picked image with a
/// retake action.
class ReportPhotoPicker extends StatelessWidget {
  const ReportPhotoPicker({
    super.key,
    required this.photoPath,
    required this.onPick,
    this.errorText,
  });

  final String? photoPath;

  /// Null disables the picker (e.g. while submitting), rendering the disabled
  /// affordance instead of an inert tap target.
  final VoidCallback? onPick;

  /// Set after a failed validation pass.
  final String? errorText;

  /// Local: no token in the scale covers a disabled-affordance dim.
  static const double _disabledOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    final disabled = onPick == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: disabled ? _disabledOpacity : 1,
          child: GestureDetector(
            onTap: onPick,
            child: ClipRRect(
              borderRadius: AppRadius.radiusXl,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: path == null
                    ? const _EmptyPhotoSlot()
                    : Image.file(File(path), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        if (path != null) ...[
          const Gap(AppSpacing.xs2),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.refresh, size: AppIconSizes.md),
              label: const Text('Retake'),
            ),
          ),
        ],
        if (errorText != null) ...[
          const Gap(AppSpacing.xs2),
          Text(
            errorText!,
            style: AppTypography.label.copyWith(
              color: AppColors.statusRejected,
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyPhotoSlot extends StatelessWidget {
  const _EmptyPhotoSlot();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.fillSubtle,
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: AppRadius.radiusXl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_a_photo_outlined,
            size: AppIconSizes.xl,
            color: AppColors.accent,
          ),
          const Gap(AppSpacing.xs2),
          Text('Add a photo of the issue', style: AppTypography.body),
        ],
      ),
    );
  }
}
