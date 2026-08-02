import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/datasources.dart';
import '../mapper/mapper.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({required this._authRemoteDataSource});

  final AuthRemoteDataSource _authRemoteDataSource;

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

    return result.toEntity();
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

    return result.toEntity();
  });
}
