import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_location_provider.g.dart';

/// The last device position that resolved successfully, kept for the pin that
/// marks it on the map.
///
/// Separate from `MapLocation`: that one goes loading on every locate tap and
/// carries the permission outcome, while the pin must stay put across a
/// re-locate and appear only once a position has actually been obtained.
@riverpod
class CurrentLocation extends _$CurrentLocation {
  @override
  LatLng? build() => null;

  void update(LatLng position) => state = position;
}
