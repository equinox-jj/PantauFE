import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../domain/entity/entity.dart';

/// Result panel under the search field, covering the loading, error, empty,
/// and data states of a place search.
///
/// It replaces the category chips while a search is active rather than
/// floating over them, so the two never fight for the same strip of map.
class MapSearchResults extends StatelessWidget {
  const MapSearchResults({
    super.key,
    required this.state,
    required this.onSelected,
    required this.onRetry,
  });

  final AsyncValue<List<Place>> state;
  final ValueChanged<Place> onSelected;
  final VoidCallback onRetry;

  /// Caps the panel so a full result set cannot swallow the map.
  static const double _maxHeight = 280;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: _maxHeight),
      decoration: BoxDecoration(
        color: AppColors.surfaceFloat,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: AppShadows.floating,
      ),
      clipBehavior: Clip.antiAlias,
      child: switch (state) {
        AsyncLoading() => const _SearchMessage(
          icon: Icons.search,
          message: 'Mencari tempat…',
          isLoading: true,
        ),
        AsyncError() => _SearchMessage(
          icon: Icons.error_outline,
          message: 'Gagal mencari tempat',
          actionLabel: 'Coba lagi',
          onAction: onRetry,
        ),
        AsyncData(:final value) when value.isEmpty => const _SearchMessage(
          icon: Icons.location_off_outlined,
          message: 'Tempat tidak ditemukan',
        ),
        AsyncData(:final value) => _SearchResultList(
          places: value,
          onSelected: onSelected,
        ),
      },
    );
  }
}

class _SearchResultList extends StatelessWidget {
  const _SearchResultList({required this.places, required this.onSelected});

  final List<Place> places;
  final ValueChanged<Place> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: places.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: AppColors.borderHairline),
      itemBuilder: (context, index) {
        final place = places[index];

        return _SearchResultTile(place: place, onTap: () => onSelected(place));
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.place, required this.onTap});

  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.place_outlined,
                size: AppIconSizes.md,
                color: AppColors.teal400,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (place.address.isNotEmpty)
                    Text(
                      place.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The non-list states: a centred icon, a line of copy, and an optional
/// action.
class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.icon,
    required this.message,
    this.isLoading = false,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final bool isLoading;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (isLoading)
            const SizedBox(
              width: AppIconSizes.md,
              height: AppIconSizes.md,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(icon, size: AppIconSizes.md, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(child: Text(message, style: AppTypography.body)),
          if (actionLabel != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}
