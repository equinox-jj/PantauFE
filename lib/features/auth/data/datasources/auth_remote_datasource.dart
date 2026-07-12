import 'package:dio/dio.dart';

import '../../../../core/base/base.dart';

abstract class AuthRemoteDataSource {}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource
    with BaseRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required this._dio,
  });

  final Dio _dio;
}
