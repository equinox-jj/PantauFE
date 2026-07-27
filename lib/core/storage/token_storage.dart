import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists access/refresh tokens. Domain code depends on this abstraction.
abstract interface class TokenStorage {
  /// Returns the stored access token, or null if absent.
  Future<String?> readAccessToken();

  /// Persists both tokens atomically (from the caller's perspective).
  Future<void> saveTokens({
    required String accessToken,
  });

  /// Removes all stored tokens.
  Future<void> clear();
}

/// [TokenStorage] backed by encrypted [FlutterSecureStorage]
/// (Keychain on iOS, EncryptedSharedPreferences/Keystore on Android).
class SecureTokenStorageImpl implements TokenStorage {
  const SecureTokenStorageImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccess = 'access_token';

  @override
  Future<String?> readAccessToken() => _storage.read(key: _kAccess);

  @override
  Future<void> saveTokens({
    required String accessToken,
  }) async => await Future.wait([
    _storage.write(key: _kAccess, value: accessToken),
  ]);

  @override
  Future<void> clear() => _storage.deleteAll();
}
