import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/core_di.dart';
import '../data/datasources/datasources.dart';
import '../data/repository/repository.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/usecase.dart';

part 'auth_di.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);

  return AuthRemoteDataSourceImpl(dioClient: dioClient);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final authRemoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  return AuthRepositoryImpl(
    authRemoteDataSource: authRemoteDataSource,
    tokenStorage: tokenStorage,
  );
}

@Riverpod(keepAlive: true)
LoginUsecase loginUsecase(Ref ref) {
  final authRepository = ref.read(authRepositoryProvider);

  return LoginUsecase(authRepository: authRepository);
}

@Riverpod(keepAlive: true)
LogoutUsecase logoutUsecase(Ref ref) {
  final authRepository = ref.read(authRepositoryProvider);

  return LogoutUsecase(authRepository: authRepository);
}

@Riverpod(keepAlive: true)
RegisterUsecase registerUsecase(Ref ref) {
  final authRepository = ref.read(authRepositoryProvider);

  return RegisterUsecase(authRepository: authRepository);
}
