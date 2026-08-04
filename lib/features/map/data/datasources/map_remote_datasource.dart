import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

import '../../../../core/base/base.dart';
import '../../../../core/network/network.dart';
import '../model/model.dart';
import 'endpoint/map_endpoint.dart';

abstract class MapRemoteDataSource with BaseRemoteDataSource {
  Future<NearbyReportsModel> getNearbyReports({
    required double latitude,
    required double longitude,
    required int radiusInMeters,
    int limit,
  });
  Future<ReportCategoriesModel> getReportCategories();
  Future<ReportDetailModel> getReportDetail(String id);

  /// Creates a report. The photo at [photoPath] is uploaded in the same
  /// multipart request — the API has no separate upload endpoint.
  Future<CreateReportModel> createReport({
    required int categoryId,
    required String description,
    required String photoPath,
    required double latitude,
    required double longitude,
  });

  /// Forward-geocodes [query] through OpenStreetMap Nominatim. [viewBox] is a
  /// pre-formatted `minLon,minLat,maxLon,maxLat` rectangle biasing results.
  Future<List<PlaceModel>> searchPlaces({
    required String query,
    String? viewBox,
    int limit,
  });
}

class MapRemoteDataSourceImpl extends MapRemoteDataSource {
  MapRemoteDataSourceImpl({required this._dioClient});

  final DioClient _dioClient;

  @override
  Future<NearbyReportsModel> getNearbyReports({
    required double latitude,
    required double longitude,
    required int radiusInMeters,
    int limit = 10,
  }) => safeApiCall(() async {
    final response = await _dioClient.get(
      MapEndpoint.nearbyReports,
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'radius_meter': radiusInMeters,
        'limit': limit,
      },
    );

    return NearbyReportsModel.fromJson(response.data);
  });

  @override
  Future<ReportCategoriesModel> getReportCategories() => safeApiCall(() async {
    final response = await _dioClient.get(MapEndpoint.reportCategories);

    return ReportCategoriesModel.fromJson(response.data);
  });

  @override
  Future<ReportDetailModel> getReportDetail(String id) => safeApiCall(() async {
    final response = await _dioClient.get(MapEndpoint.reportDetail(id));

    return ReportDetailModel.fromJson(response.data);
  });

  @override
  Future<CreateReportModel> createReport({
    required int categoryId,
    required String description,
    required String photoPath,
    required double latitude,
    required double longitude,
  }) => safeApiCall(() async {
    // Field names follow docs/API_REQUEST.md: scalars as form-data text parts,
    // the photo as the `photo` file part.
    final formData = FormData.fromMap({
      'categoryId': '$categoryId',
      'description': description,
      'latitude': '$latitude',
      'longitude': '$longitude',
      'photo': await MultipartFile.fromFile(
        photoPath,
        filename: p.basename(photoPath),
      ),
    });

    final response = await _dioClient.post(
      MapEndpoint.reports,
      data: formData,
      // Dio applies sendTimeout to the whole request body, so the global 10s
      // default is too tight for a photo on a weak uplink. Request-scoped, so
      // the DioClient defaults stay untouched.
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    return CreateReportModel.fromJson(response.data);
  });

  @override
  Future<List<PlaceModel>> searchPlaces({
    required String query,
    String? viewBox,
    int limit = 6,
  }) => safeApiCall(() async {
    final response = await _dioClient.get<List<dynamic>>(
      // Absolute URL, so Dio ignores the Pantau base URL for this call only.
      'https://nominatim.openstreetmap.org/search',
      options: Options(
        // Required by the Nominatim usage policy; requests without one are
        // rejected.
        headers: const {'User-Agent': 'Pantau/1.0 (com.pantau.app)'},
        // Keeps AuthInterceptor from sending the Pantau token to a third party.
        extra: const {ApiEndpoints.kNoAuth: true},
      ),
      queryParameters: {
        'q': query,
        'format': 'jsonv2',
        'limit': limit,
        'addressdetails': 1,
        // Indonesia only: short queries otherwise resolve to same-named places
        // abroad.
        'countrycodes': 'id',
        'accept-language': 'id',
        // Sent without `bounded=1`, so it ranks nearby hits higher rather than
        // hiding everything outside the camera.
        'viewbox': ?viewBox,
      },
    );

    return (response.data ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(PlaceModel.fromJson)
        .toList(growable: false);
  });
}
