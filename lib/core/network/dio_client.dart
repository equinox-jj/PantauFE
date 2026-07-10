import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'interceptors/refresh_interceptor.dart';

/// Builds and owns the configured [Dio] instance used across the app.
class DioClient {
  DioClient({
    required AuthInterceptor authInterceptor,
    required RefreshInterceptor refreshInterceptor,
    Dio? dio,
  }) : dio = dio ?? Dio() {
    this.dio
      ..options = BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
      )
      ..interceptors.addAll([
        authInterceptor,
        refreshInterceptor,
        LoggerInterceptor(),
      ]);
  }

  /// The configured Dio instance.
  final Dio dio;
}
