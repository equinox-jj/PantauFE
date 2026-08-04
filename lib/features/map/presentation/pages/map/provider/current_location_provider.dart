import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_location_provider.g.dart';

/// The last device position that resolved, for the pin marking it on the map.
///
/// Separate from `MapLocation`, which goes loading on every locate tap and
/// carries the permission outcome; the pin must stay put across a re-locate.
@riverpod
class CurrentLocation extends _$CurrentLocation {
  @override
  LatLng? build() => null;

  void update(LatLng position) => state = position;
}
