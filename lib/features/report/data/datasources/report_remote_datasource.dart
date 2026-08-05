import '../../../../core/base/base.dart';
import '../../../../core/network/network.dart';
import '../model/model.dart';
import 'endpoint/report_endpoint.dart';

abstract class ReportRemoteDataSource with BaseRemoteDataSource {
  /// Reports within [radiusInMeters] of the point, nearest first.
  Future<FeedReportsModel> getFeedReports({
    required double latitude,
    required double longitude,
    required int radiusInMeters,
    int limit,
  });
}

class ReportRemoteDataSourceImpl extends ReportRemoteDataSource {
  ReportRemoteDataSourceImpl({required this._dioClient});

  final DioClient _dioClient;

  @override
  Future<FeedReportsModel> getFeedReports({
    required double latitude,
    required double longitude,
    required int radiusInMeters,
    int limit = 50,
  }) => safeApiCall(() async {
    final response = await _dioClient.get(
      ReportEndpoint.nearbyReports,
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'radius_meter': radiusInMeters,
        'limit': limit,
      },
    );

    return FeedReportsModel.fromJson(response.data);
  });
}
