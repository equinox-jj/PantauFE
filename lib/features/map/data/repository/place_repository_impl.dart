import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repository/repository.dart';
import '../datasources/datasources.dart';
import '../mapper/mapper.dart';

class PlaceRepositoryImpl extends PlaceRepository {
  PlaceRepositoryImpl({required this._mapRemoteDataSource});

  final MapRemoteDataSource _mapRemoteDataSource;

  @override
  Future<Either<Failure, List<Place>>> searchPlaces({
    required String query,
    PlaceViewBox? viewBox,
    int limit = 6,
  }) => safeCall(() async {
    final result = await _mapRemoteDataSource.searchPlaces(
      query: query,
      viewBox: viewBox == null ? null : _formatViewBox(viewBox),
      limit: limit,
    );

    return result.toEntities();
  });

  /// Nominatim expects `minLon,minLat,maxLon,maxLat` — longitude first, which
  /// is the reverse of how the rest of the app orders coordinates.
  String _formatViewBox(PlaceViewBox viewBox) {
    return '${viewBox.minLongitude},${viewBox.minLatitude},'
        '${viewBox.maxLongitude},${viewBox.maxLatitude}';
  }
}
