import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/utils/enums/enums.dart';

part 'queue_tab_notifier.g.dart';

/// Which segment of the queue is showing. Lives outside the page so
/// switching tabs does not rebuild the whole screen, only what watches this.
@riverpod
class QueueTabSelection extends _$QueueTabSelection {
  @override
  QueueTab build() => QueueTab.open;

  void select(QueueTab tab) {
    if (state == tab) return;

    state = tab;
  }
}
