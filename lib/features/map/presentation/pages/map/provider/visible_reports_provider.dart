import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entity/entity.dart';
import 'nearby_reports_notifier.dart';

part 'visible_reports_provider.g.dart';

/// The report list currently on screen: the last successfully loaded page of
/// [nearbyReportsProvider], held across its loading and error states.
///
/// Markers would otherwise blink out on every pan-triggered refetch, and the
/// empty/error overlays would flash over a map that still has pins on it.
/// Listening (not watching) is what makes it a memo — the previous list
/// survives until a newer one arrives.
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
