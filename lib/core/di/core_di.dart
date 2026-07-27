import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/interceptors/interceptors.dart';
import '../network/network.dart';
import '../storage/storage.dart';

part 'core_di.g.dart';

@Riverpod(keepAlive: true)
SessionManager sessionManager(Ref ref) {
  return SessionManager();
}

@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  final authInterceptor = ref.watch(authInterceptorProvider);

  return DioClient(
    authInterceptor: authInterceptor,
  );
}

@Riverpod(keepAlive: true)
AuthInterceptor authInterceptor(Ref ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);

  return AuthInterceptor(tokenStorage);
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);

  return SecureTokenStorageImpl(secureStorage);
}

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}
