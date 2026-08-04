import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/error/error.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../domain/entity/entity.dart';
import '../../../provider/provider.dart';

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
              AsyncValue(value: final categories?) => _CategoryChips(
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
