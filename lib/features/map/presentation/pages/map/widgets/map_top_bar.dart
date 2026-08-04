import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../domain/entity/entity.dart';
import '../provider/provider.dart';
import 'map_filter_bar.dart';
import 'map_search_field.dart';
import 'map_search_results.dart';

/// The place-search field, and below it either the search results or the
/// category filter chips.
///
/// Owns the scrim and the safe area for both, so the strip fades into the map
/// as one surface.
class MapTopBar extends StatelessWidget {
  const MapTopBar({
    super.key,
    required this.onSearchSubmitted,
    required this.onSearchCleared,
    required this.onPlaceSelected,
  });

  /// The trimmed query from the keyboard's search action.
  final ValueChanged<String> onSearchSubmitted;

  /// Fired by the field's clear button.
  final VoidCallback onSearchCleared;

  final ValueChanged<Place> onPlaceSelected;

  /// Scrim below the content, so the bar fades out instead of ending on a
  /// hard edge.
  static const _scrimFade = AppSpacing.xl2;

  /// Height below the status bar, for anything the map stacks under the bar.
  /// Measured against the chip row, not the taller results panel.
  static const height =
      AppSpacing.xs2 +
      MapSearchField.height +
      AppSpacing.xs2 +
      MapFilterBar.height +
      _scrimFade;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: _scrim),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xs2,
              bottom: _scrimFade,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: MapSearchField(
                    onSubmitted: onSearchSubmitted,
                    onCleared: onSearchCleared,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs2),
                _SearchResultsOrFilters(onPlaceSelected: onPlaceSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Scrim behind the bar. Opaque only where the status bar text sits, then
/// stepped through partial alphas — a single hard stop to transparent read as
/// a dark slab under the search field.
const _scrim = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    AppColors.surfaceBase,
    Color(0xD9050C0B), // surfaceBase · .85
    Color(0x8C050C0B), // surfaceBase · .55
    Color(0x33050C0B), // surfaceBase · .2
    Colors.transparent,
  ],
  stops: [0, 0.35, 0.62, 0.82, 1],
);

/// The second row of the bar. Shows the results panel while a search is open
/// and the chips otherwise — never both, so nothing overlaps.
class _SearchResultsOrFilters extends StatelessWidget {
  const _SearchResultsOrFilters({required this.onPlaceSelected});

  final ValueChanged<Place> onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(placeSearchProvider);
        // Null means the panel is closed; loading, failed, and empty searches
        // all still have something to show.
        if (state == null) return child!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: MapSearchResults(
            state: state,
            onSelected: onPlaceSelected,
            onRetry: () => ref.read(placeSearchProvider.notifier).retry(),
          ),
        );
      },
      child: const MapFilterBar(),
    );
  }
}
