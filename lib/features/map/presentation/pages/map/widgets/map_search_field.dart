import 'package:flutter/material.dart';

import '../../../../../../core/components/textfield/textfield.dart';
import '../../../../../../core/theme/theme.dart';

/// Place-search input above the map.
///
/// Submit-driven, not reactive: [onSubmitted] fires on the keyboard's search
/// action, so one search is one request to the geocoder.
class MapSearchField extends StatefulWidget {
  const MapSearchField({
    super.key,
    required this.onSubmitted,
    required this.onCleared,
  });

  /// The trimmed query. Never called with an empty string.
  final ValueChanged<String> onSubmitted;

  /// Fired by the trailing clear button — drops both the results panel and
  /// the pin on the map.
  final VoidCallback onCleared;

  /// Height [AppTextField] settles at under the app's input theme, published
  /// so the top bar can stack against it without measuring.
  static const double height = AppSpacing.xl4;

  @override
  State<MapSearchField> createState() => _MapSearchFieldState();
}

class _MapSearchFieldState extends State<MapSearchField> {
  final TextEditingController _controller = TextEditingController();

  /// Drives the trailing button only. Held in state rather than read from the
  /// controller so the icon swaps as the user types.
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTextChanged)
      ..dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText == _hasText) return;

    setState(() => _hasText = hasText);
  }

  void _handleSubmitted(String value) {
    final query = value.trim();
    if (query.isEmpty) return;

    widget.onSubmitted(query);
  }

  void _handleClear() {
    _controller.clear();
    FocusScope.of(context).unfocus();
    widget.onCleared();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // The field's own fill is translucent, so the map would otherwise show
      // through it. An opaque plate behind it also carries the drop shadow
      // that lifts the field off the tiles.
      decoration: const BoxDecoration(
        color: AppColors.surfaceFloat,
        borderRadius: AppRadius.radiusLg,
        boxShadow: AppShadows.floating,
      ),
      child: AppTextField(
        controller: _controller,
        hintText: 'Cari tempat',
        prefixIcon: Icons.search,
        suffixIcon: _hasText ? Icons.close : null,
        onSuffixIconTap: _handleClear,
        suffixIconTooltip: 'Hapus pencarian',
        textInputAction: TextInputAction.search,
        onFieldSubmitted: _handleSubmitted,
      ),
    );
  }
}
