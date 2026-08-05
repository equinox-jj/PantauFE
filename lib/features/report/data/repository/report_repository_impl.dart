import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repository/repository.dart';
import '../datasources/datasources.dart';
import '../mapper/mapper.dart';

class ReportRepositoryImpl extends ReportRepository {
  ReportRepositoryImpl({required this._reportRemoteDataSource});

  final ReportRemoteDataSource _reportRemoteDataSource;

  @override
  Future<Either<Failure, List<FeedReport>>> getFeedReports({
    required double latitude,
    required double longitude,
    required int radiusInMeters,
    int limit = 50,
  }) => safeCall(() async {
    final result = await _reportRemoteDataSource.getFeedReports(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
      limit: limit,
    );

    return result.toEntities();
  });
}
