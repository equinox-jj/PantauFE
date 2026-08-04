import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loaded_area_provider.g.dart';

/// Centre of the last nearby-reports fetch, kept for the ring the map draws
/// around it.
///
/// Deliberately not `CurrentLocation`: the fetch follows whatever the user
/// last asked to look at — the device position at startup, a searched place,
/// or the camera centre behind "Search this area" — and the ring has to mark
/// the ground actually loaded, not where the user happens to be standing.
@riverpod
class LoadedArea extends _$LoadedArea {
  @override
  LatLng? build() => null;

  void update(LatLng center) => state = center;
}
