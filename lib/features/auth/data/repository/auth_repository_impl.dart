import '../../domain/repository/auth_repository.dart';
import '../datasources/datasources.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required this._authRemoteDataSource,
  });

  final AuthRemoteDataSource _authRemoteDataSource;
}
