import 'dart:io';

import 'package:material_ui/material_ui.dart';
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

/// Photo slots of the compose form: 1 to [maxPhotos] images as a grid of
/// square tiles, each removable, plus an add tile while under the cap.
///
/// Before any fresh photo is picked on a resubmit, the rejected report's own
/// photo is shown once as a dimmed reference tile that doubles as the add
/// trigger — reference only, since filing always needs a fresh local file.
class ReportPhotoPicker extends StatelessWidget {
  const ReportPhotoPicker({
    super.key,
    required this.photoPaths,
    required this.maxPhotos,
    required this.onAdd,
    required this.onRemove,
    this.errorText,
    this.initialPhotoUrl,
  });

  final List<String> photoPaths;

  /// Upper bound on [photoPaths]; the add tile hides once this is reached.
  final int maxPhotos;

  /// Null disables adding (e.g. while submitting), rendering the disabled
  /// affordance instead of an inert tap target.
  final VoidCallback? onAdd;

  /// Null disables removal (e.g. while submitting).
  final ValueChanged<int>? onRemove;

  /// Set after a failed validation pass.
  final String? errorText;

  /// The photo of the report being resubmitted. Reference only — a report can
  /// only ever be filed with fresh local files, so this never satisfies the
  /// photo requirement on its own; picking the first new photo replaces it.
  final String? initialPhotoUrl;

  static const double _tileSize = 84;

  @override
  Widget build(BuildContext context) {
    final showReference = photoPaths.isEmpty && initialPhotoUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Photos', style: AppTypography.label),
            const Spacer(),
            Text(
              '${photoPaths.length}/$maxPhotos',
              style: AppTypography.label.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
        const Gap(AppSpacing.xs2),
        Wrap(
          spacing: AppSpacing.xs2,
          runSpacing: AppSpacing.xs2,
          children: [
            if (showReference)
              _PreviousPhotoSlot(
                photoUrl: initialPhotoUrl,
                onTap: onAdd,
                size: _tileSize,
              )
            else ...[
              for (var index = 0; index < photoPaths.length; index++)
                _PickedPhotoTile(
                  path: photoPaths[index],
                  onRemove: onRemove == null ? null : () => onRemove!(index),
                  size: _tileSize,
                ),
              if (photoPaths.length < maxPhotos)
                _AddPhotoTile(onTap: onAdd, size: _tileSize),
            ],
          ],
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

/// One picked photo, with a corner button to remove it.
class _PickedPhotoTile extends StatelessWidget {
  const _PickedPhotoTile({
    required this.path,
    required this.onRemove,
    required this.size,
  });

  final String path;
  final VoidCallback? onRemove;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: AppRadius.radiusLg,
            child: Image.file(
              File(path),
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: _RemoveButton(onPressed: onRemove!),
            ),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onPressed});

  final VoidCallback onPressed;

  static const double _size = 22;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: AppColors.surfaceSunken.withValues(alpha: 0.75),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: AppIconSizes.sm,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Empty tile that opens the picker; doubles as the only tile shown before
/// the first photo is picked.
class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap, required this.size});

  final VoidCallback? onTap;
  final double size;

  /// Local: no token in the scale covers a disabled-affordance dim.
  static const double _disabledOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? _disabledOpacity : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.fillSubtle,
            border: Border.all(color: AppColors.borderDefault),
            borderRadius: AppRadius.radiusLg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_a_photo_outlined,
                size: AppIconSizes.md,
                color: AppColors.accent,
              ),
              const Gap(2),
              Text('Add', style: AppTypography.label),
            ],
          ),
        ),
      ),
    );
  }
}

/// A resubmission's starting point: the rejected report's own photo, dimmed
/// under a prompt — reference only, since filing still needs fresh local
/// files.
class _PreviousPhotoSlot extends StatelessWidget {
  const _PreviousPhotoSlot({
    required this.photoUrl,
    required this.onTap,
    required this.size,
  });

  final String? photoUrl;
  final VoidCallback? onTap;
  final double size;

  static const double _scrimOpacity = 0.55;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppRadius.radiusXl,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (url != null)
                Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const ColoredBox(color: AppColors.fillSubtle),
                )
              else
                const ColoredBox(color: AppColors.fillSubtle),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceSunken.withValues(
                    alpha: _scrimOpacity,
                  ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(
                        'Photo from the rejected report — tap to add 1 to '
                        '4 photos',
                        style: AppTypography.body,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
