import 'package:dio/dio.dart';

import '../../local_storage/token_storage.dart';
import '../api_endpoints.dart';
import '../session_manager.dart';

/// Attaches the `x-api-key` header to every request and a
/// `Authorization: Bearer` header unless the request is flagged `noAuth`.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._sessionManager);

  final TokenStorage _tokenStorage;
  final SessionManager _sessionManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final noAuth = options.extra[ApiEndpoints.kNoAuth] == true;
    if (!noAuth) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final noAuth = err.requestOptions.extra[ApiEndpoints.kNoAuth] == true;

    // A 401 on an authenticated call means the stored token is no longer good.
    // Drop it and let the router send the user back to login. Auth endpoints
    // are excluded — there a 401 just means wrong credentials.
    if (!noAuth && err.response?.statusCode == 401) {
      await _tokenStorage.clear();
      _sessionManager.notifyExpired();
    }

    handler.next(err);
  }
}
