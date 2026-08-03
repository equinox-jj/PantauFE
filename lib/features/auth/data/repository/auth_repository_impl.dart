import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error.dart';
import '../../../../core/local_storage/local_storage.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/datasources.dart';
import '../mapper/mapper.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required this._authRemoteDataSource,
    required this._tokenStorage,
  });

  final AuthRemoteDataSource _authRemoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<Either<Failure, Register>> register({
    required String email,
    required String password,
    required String displayName,
  }) => safeCall(() async {
    final result = await _authRemoteDataSource.register(
      email: email,
      password: password,
      displayName: displayName,
    );
    final entity = result.toEntity();

    // The API signs the user in on register, so the token is persisted here
    // too — otherwise every authenticated call after sign-up returns 401.
    await _persistToken(entity.data?.token);

    return entity;
  });

  @override
  Future<Either<Failure, Login>> login({
    required String email,
    required String password,
  }) => safeCall(() async {
    final result = await _authRemoteDataSource.login(
      email: email,
      password: password,
    );
    final entity = result.toEntity();

    // AuthInterceptor reads the token straight from storage, so it has to land
    // here before any authenticated request is made.
    await _persistToken(entity.data?.token);

    return entity;
  });

  @override
  Future<Either<Failure, void>> logout() =>
      safeCall(() => _tokenStorage.clear());

  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) return;

    await _tokenStorage.saveTokens(accessToken: token);
  }
}
