import 'package:fpdart/fpdart.dart';
import 'package:pantau/features/auth/domain/entity/entity.dart';

import '../../../../core/error/error.dart';

abstract class AuthRepository {
  Future<Either<Failure, Register>> register({
    required String email,
    required String password,
    required String displayName,
  });
  Future<Either<Failure, Login>> login({
    required String email,
    required String password,
  });
}
