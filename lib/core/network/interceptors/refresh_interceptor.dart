import 'dart:async';

import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';
import '../api_endpoints.dart';
import '../session_manager.dart';

/// Handles HTTP 401 by refreshing the access token exactly once for any burst
/// of concurrent failures (single-flight), then retrying every queued request
/// with the new token.
class RefreshInterceptor extends Interceptor {
  /// Creates a [RefreshInterceptor].
  ///
  /// [tokenStorage] reads/writes tokens. [sessionManager] emits session-expired
  /// events. [refreshDio] and [retryDio] are bare Dio instances (no interceptors)
  /// to avoid recursion.
  // Private fields are intentional — callers must not mutate bare Dio instances.
  // ignore: prefer_initializing_formals
  RefreshInterceptor({
    required this._tokenStorage,
    required this._sessionManager,
    required this._refreshDio,
    required this._retryDio,
  });

  /// Token persistence used to read the refresh token and save new tokens.
  final TokenStorage _tokenStorage;

  /// Emits [SessionManager.onSessionExpired] when a refresh fails.
  final SessionManager _sessionManager;

  /// Bare Dio (no interceptors) used for the refresh call — prevents recursion.
  final Dio _refreshDio;

  /// Bare Dio (no interceptors) used to replay the original request.
  final Dio _retryDio;

  /// Single-flight lock. Non-null while a refresh is in progress; completes
  /// with the new access token, or null if refresh failed.
  Completer<String?>? _refreshCompleter;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isNoAuth = err.requestOptions.extra[ApiEndpoints.kNoAuth] == true;
    final alreadyRetried =
        err.requestOptions.extra[ApiEndpoints.kRetried] == true;

    if (!isUnauthorized || isNoAuth || alreadyRetried) {
      handler.next(err);
      return;
    }

    final newToken = await _refreshToken();

    if (newToken == null) {
      handler.reject(err);
      return;
    }

    try {
      final response = await _retry(err.requestOptions, newToken);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.reject(e);
    } catch (e) {
      handler.reject(
        DioException(requestOptions: err.requestOptions, error: e),
      );
    }
  }

  /// Returns a fresh access token, performing at most one network refresh for
  /// concurrent callers (single-flight via a shared [Completer]).
  /// Returns null on failure.
  Future<String?> _refreshToken() {
    final inFlight = _refreshCompleter;
    if (inFlight != null) {
      // Follower: wait for the leader's result.
      return inFlight.future;
    }

    // Leader: own the refresh.
    final completer = Completer<String?>();
    _refreshCompleter = completer;

    unawaited(
      _performRefresh().then(
        (token) {
          _refreshCompleter = null;
          completer.complete(token);
        },
        onError: (Object _) {
          _refreshCompleter = null;
          completer.complete(null);
        },
      ),
    );

    return completer.future;
  }

  Future<String?> _performRefresh() async {
    try {
      final refreshToken = await _tokenStorage.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _onRefreshFailed();
        return null;
      }

      final response = await _refreshDio.post<dynamic>(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );
      final data = response.data as Map<String, dynamic>;
      final newAccess = data['access_token'] as String;
      final newRefresh = (data['refresh_token'] as String?) ?? refreshToken;

      await _tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      return newAccess;
    } catch (_) {
      await _onRefreshFailed();
      return null;
    }
  }

  Future<void> _onRefreshFailed() async {
    await _tokenStorage.clear();
    _sessionManager.notifyExpired();
  }

  Future<Response<dynamic>> _retry(
    RequestOptions options,
    String newToken,
  ) {
    final headers = Map<String, dynamic>.from(options.headers)
      ..['Authorization'] = 'Bearer $newToken';
    final extra = Map<String, dynamic>.from(options.extra)
      ..[ApiEndpoints.kRetried] = true;

    final retried = options.copyWith(headers: headers, extra: extra);
    return _retryDio.fetch<dynamic>(retried);
  }
}
