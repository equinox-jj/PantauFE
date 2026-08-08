// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_location_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the device-location request for the queue tab.
///
/// The queue is defined as "reports around the resolver", so this is also
/// its fetch trigger: the listener turns a successful fix into a
/// [QueueReports] load and every other outcome into a designed state.

@ProviderFor(QueueLocation)
final queueLocationProvider = QueueLocationProvider._();

/// Owns the device-location request for the queue tab.
///
/// The queue is defined as "reports around the resolver", so this is also
/// its fetch trigger: the listener turns a successful fix into a
/// [QueueReports] load and every other outcome into a designed state.
final class QueueLocationProvider
    extends $NotifierProvider<QueueLocation, AsyncValue<LocationResult?>> {
  /// Owns the device-location request for the queue tab.
  ///
  /// The queue is defined as "reports around the resolver", so this is also
  /// its fetch trigger: the listener turns a successful fix into a
  /// [QueueReports] load and every other outcome into a designed state.
  QueueLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueLocationHash();

  @$internal
  @override
  QueueLocation create() => QueueLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<LocationResult?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<LocationResult?>>(value),
    );
  }
}

String _$queueLocationHash() => r'68f4d683f3121d3a64c76bb9fb33dce7a16dc493';

/// Owns the device-location request for the queue tab.
///
/// The queue is defined as "reports around the resolver", so this is also
/// its fetch trigger: the listener turns a successful fix into a
/// [QueueReports] load and every other outcome into a designed state.

abstract class _$QueueLocation extends $Notifier<AsyncValue<LocationResult?>> {
  AsyncValue<LocationResult?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<LocationResult?>, AsyncValue<LocationResult?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<LocationResult?>,
                AsyncValue<LocationResult?>
              >,
              AsyncValue<LocationResult?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
