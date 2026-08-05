import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repository/repository.dart';
import '../datasources/datasources.dart';
import '../mapper/mapper.dart';

class MapRepositoryImpl extends MapRepository {
  MapRepositoryImpl({required this._mapRemoteDataSource});

  final MapRemoteDataSource _mapRemoteDataSource;

  @override
  Future<Either<Failure, List<NearbyReport>>> getNearbyReports({
    required double latitude,
    required double longitude,
    required int radiusInMeters,
    int limit = 10,
  }) => safeCall(() async {
    final result = await _mapRemoteDataSource.getNearbyReports(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
      limit: limit,
    );

    return result.toEntities();
  });

  @override
  Future<Either<Failure, List<ReportCategory>>> getReportCategories() =>
      safeCall(() async {
        final result = await _mapRemoteDataSource.getReportCategories();

        return result.toEntities();
      });

  @override
  Future<Either<Failure, ReportDetail>> getReportDetail(String id) =>
      safeCall(() async {
        final result = await _mapRemoteDataSource.getReportDetail(id);

        return result.toEntity();
      });

  @override
  Future<Either<Failure, List<StatusHistoryEntry>>> getReportHistory(
    String id,
  ) => safeCall(() async {
    final result = await _mapRemoteDataSource.getReportHistory(id);

    return result.toEntities();
  });

  @override
  Future<Either<Failure, ReportDetail>> createReport({
    required int categoryId,
    required String description,
    required String photoPath,
    required double latitude,
    required double longitude,
  }) => safeCall(() async {
    final result = await _mapRemoteDataSource.createReport(
      categoryId: categoryId,
      description: description,
      photoPath: photoPath,
      latitude: latitude,
      longitude: longitude,
    );

    return result.toEntity();
  });
}
