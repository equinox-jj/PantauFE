import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entity/entity.dart';

part 'searched_place_provider.g.dart';

/// The place the user jumped to, marked with a pin on the map.
///
/// Separate from [PlaceSearch] because the two have different lifetimes: the
/// result list disappears as soon as the panel closes, while the pin stays
/// until the user clears the search field.
@riverpod
class SearchedPlace extends _$SearchedPlace {
  @override
  Place? build() => null;

  void select(Place place) => state = place;

  void clear() => state = null;
}
