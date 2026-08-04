import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';

/// A geocoded place the user can jump the map to.
///
/// Every field is non-null: a hit without usable coordinates is dropped during
/// mapping rather than reaching the UI as an unplottable row.
@freezed
abstract class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
  }) = _Place;
}

/// Rectangle used to bias search results toward the current camera.
///
/// A plain value object so the domain never depends on `flutter_map` — the
/// notifier builds it from `MapCamera.visibleBounds`, and the repository
/// formats it for the geocoder.
@freezed
abstract class PlaceViewBox with _$PlaceViewBox {
  const factory PlaceViewBox({
    required double minLatitude,
    required double minLongitude,
    required double maxLatitude,
    required double maxLongitude,
  }) = _PlaceViewBox;
}
