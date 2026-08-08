import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/di/core_di.dart';
import '../../../../../../core/service/service.dart';

part 'queue_location_notifier.g.dart';

/// Owns the device-location request for the queue tab.
///
/// The queue is defined as "reports around the resolver", so this is also
/// its fetch trigger: the listener turns a successful fix into a
/// [QueueReports] load and every other outcome into a designed state.
@riverpod
class QueueLocation extends _$QueueLocation {
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
