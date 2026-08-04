import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loaded_area_provider.g.dart';

/// Centre of the last nearby-reports fetch, for the ring drawn around it.
///
/// Not `CurrentLocation`: the fetch follows whatever the user last asked to
/// look at, and the ring must mark the ground actually loaded.
@riverpod
class LoadedArea extends _$LoadedArea {
  @override
  LatLng? build() => null;

  void update(LatLng center) => state = center;
}
