import 'package:fpdart/fpdart.dart';

import '../../../../core/base/base.dart';
import '../../../../core/error/error.dart';
import '../entity/entity.dart';

abstract class MapRepository with BaseRepository {
  Future<Either<Failure, List<NearbyReport>>> getNearbyReports({
    required double latitude,
    required double longitude,
    required int radiusInMeters,
    int limit,
  });

  Future<Either<Failure, List<ReportCategory>>> getReportCategories();

  Future<Either<Failure, ReportDetail>> getReportDetail(String id);

  /// Creates a report, uploading the photo at [photoPath] in the same
  /// request.
  Future<Either<Failure, ReportDetail>> createReport({
    required int categoryId,
    required String description,
    required String photoPath,
    required double latitude,
    required double longitude,
  });
}
