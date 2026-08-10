import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/utils/enums/enums.dart';

part 'resolver_map_tab_notifier.g.dart';

/// The map's own tab selection. Independent of `QueueTabSelection` —
/// switching tabs on the map never changes what the Queue page shows next,
/// and vice versa. Defaults to the actionable "open" bucket.
@riverpod
class ResolverMapTabSelection extends _$ResolverMapTabSelection {
  @override
  QueueTab build() => QueueTab.open;

  void select(QueueTab tab) => state = tab;
}
