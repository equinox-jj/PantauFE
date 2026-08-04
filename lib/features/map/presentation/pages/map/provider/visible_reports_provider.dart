import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entity/entity.dart';
import 'nearby_reports_notifier.dart';

part 'visible_reports_provider.g.dart';

/// The last successfully loaded page of [nearbyReportsProvider], held across
/// its loading and error states.
///
/// Markers would otherwise blink out on every pan refetch. Listening rather
/// than watching is what memoises it: the previous list survives until a newer
/// one arrives.
@riverpod
class VisibleReports extends _$VisibleReports {
  @override
  List<NearbyReport> build() {
    ref.listen(nearbyReportsProvider, (previous, next) {
      if (next.value case final reports?) state = reports;
    });

    return ref.read(nearbyReportsProvider).value ?? const [];
  }
}
