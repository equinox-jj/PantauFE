import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/theme/theme.dart';

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

  /// Null disables the picker (e.g. while submitting), rendering the
  /// disabled affordance instead of an inert tap target.
  final VoidCallback? onPick;

  /// Set after a failed validation pass to explain the photo is required.
  final String? errorText;

  /// No token in the spacing/opacity scale covers a disabled-affordance
  /// dim, so it's declared locally (matching how [ReportLocationPicker]
  /// declares its own one-off constants).
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
