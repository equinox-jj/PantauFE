import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../di/di.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/usecase/usecase.dart';

part 'update_status_notifier.g.dart';

/// Advances a report's status. Same one-shot shape as `CreateReport` — no
/// family, so the action panel, the picker sheet and the page listener all
/// watch a single in-flight submission per detail-page visit. Autodispose
/// (no `keepAlive`) resets it the moment the page is left.
@riverpod
class UpdateStatus extends _$UpdateStatus {
  @override
  AsyncValue<ReportDetail?> build() => const AsyncData(null);

  Future<void> submit({
    required String reportId,
    required ReportStatus toStatus,
    String? note,
  }) async {
    state = const AsyncLoading();

    final result = await ref.read(updateReportStatusUsecaseProvider)(
      UpdateReportStatusParams(id: reportId, toStatus: toStatus, note: note),
    );
    if (!ref.mounted) return;

    result.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }
}
