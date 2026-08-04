import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/di/core_di.dart';
import '../../../../../../core/service/service.dart';

part 'map_location_notifier.g.dart';

/// Owns the device-location request for the map tab. Holds the raw
/// [LocationResult] so the listener can branch on permission outcomes.
@riverpod
class MapLocation extends _$MapLocation {
  @override
  AsyncValue<LocationResult?> build() => const AsyncData(null);

  Future<void> locate() async {
    state = const AsyncLoading();

    final locationService = ref.read(locationServiceProvider);
    final result = await locationService.getCurrentLocation();
    if (!ref.mounted) return;

    state = AsyncData(result);
  }

  Future<void> openSettings() =>
      ref.read(locationServiceProvider).openSettings();
}
