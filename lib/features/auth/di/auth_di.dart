import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/core_di.dart';
import '../data/datasources/datasources.dart';
import '../data/repository/repository.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/usecase.dart';

part 'auth_di.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);

  return AuthRemoteDataSourceImpl(dio: dio);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final authRemoteDataSource = ref.watch(authRemoteDataSourceProvider);

  return AuthRepositoryImpl(
    authRemoteDataSource: authRemoteDataSource,
  );
}

@riverpod
LoginUsecase loginUsecase(Ref ref) {
  return LoginUsecase();
}

@riverpod
RegisterUsecase registerUsecase(Ref ref) {
  return RegisterUsecase();
}
