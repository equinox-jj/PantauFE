import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entity/entity.dart';

part 'searched_place_provider.g.dart';

/// The place the user jumped to, marked with a pin on the map.
///
/// Separate from [PlaceSearch] for lifetime: the result list dies with the
/// panel, the pin stays until the search field is cleared.
@riverpod
class SearchedPlace extends _$SearchedPlace {
  @override
  Place? build() => null;

  void select(Place place) => state = place;

  void clear() => state = null;
}
