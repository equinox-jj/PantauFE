import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/di.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/usecase/usecase.dart';

part 'report_detail_provider.g.dart';

/// Loads one report by id. Throws the [Failure] so the sheet can render it
/// through `AsyncValue.error`.
@riverpod
Future<ReportDetail> reportDetail(Ref ref, String reportId) async {
  final usecase = ref.watch(getReportDetailUsecaseProvider);
  final result = await usecase(GetReportDetailParams(id: reportId));

  return result.fold((failure) => throw failure, (detail) => detail);
}
