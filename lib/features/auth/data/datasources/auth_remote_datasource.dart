import 'package:pantau/features/auth/data/model/model.dart';

import '../../../../core/base/base.dart';
import '../../../../core/network/network.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterModel> register({
    required String email,
    required String password,
    required String displayName,
  });
  Future<LoginModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource
    with BaseRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required this._dioClient,
  });

  final DioClient _dioClient;

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) => safeApiCall(() async {
    final response = await _dioClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    return LoginModel.fromJson(response.data);
  });

  @override
  Future<RegisterModel> register({
    required String email,
    required String password,
    required String displayName,
  }) => safeApiCall(() async {
    final response = await _dioClient.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'displayName': displayName,
      },
    );

    return RegisterModel.fromJson(response.data);
  });
}
