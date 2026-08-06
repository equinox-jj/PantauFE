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
  Future<StatusHistoryModel> getReportHistory(String id);

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

  /// Reverse-geocodes a coordinate through OpenStreetMap Nominatim. Returns
  /// null when the point has no addressable feature (open sea, unmapped area).
  Future<PlaceModel?> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}

class MapRemoteDataSourceImpl extends MapRemoteDataSource {
  MapRemoteDataSourceImpl({required this._dioClient});

  final DioClient _dioClient;

  static const _nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  /// Options shared by every Nominatim call: the usage policy rejects requests
  /// without a User-Agent, and the Pantau token must never leave for a third
  /// party.
  static final _nominatimOptions = Options(
    headers: const {'User-Agent': 'Pantau/1.0 (com.pantau.app)'},
    extra: const {ApiEndpoints.kNoAuth: true},
  );

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
  Future<StatusHistoryModel> getReportHistory(String id) =>
      safeApiCall(() async {
        final response = await _dioClient.get(MapEndpoint.reportHistory(id));
        final data = response.data;

        // docs/Pantau_openapi.yaml types this response as a bare array, while
        // every other endpoint wraps its payload in {status, message, data}.
        // Both shapes are accepted so the screen survives either backend.
        if (data is List) {
          return StatusHistoryModel(
            data: data
                .whereType<Map<String, dynamic>>()
                .map(StatusHistoryEntryModel.fromJson)
                .toList(growable: false),
          );
        }

        return StatusHistoryModel.fromJson(data);
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
      '$_nominatimBaseUrl/search',
      options: _nominatimOptions,
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

  @override
  Future<PlaceModel?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) => safeApiCall(() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '$_nominatimBaseUrl/reverse',
      options: _nominatimOptions,
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'format': 'jsonv2',
        'addressdetails': 1,
        'accept-language': 'id',
        // Street-level detail: the pin marks a spot on a road, not a region.
        'zoom': 18,
      },
    );

    final data = response.data;
    // Nominatim answers 200 with `{"error": "Unable to geocode"}` for a point
    // it cannot name, so a missing coordinate — not the status code — is what
    // marks "no address here".
    if (data == null || data['lat'] == null || data['lon'] == null) return null;

    return PlaceModel.fromJson(data);
  });
}
