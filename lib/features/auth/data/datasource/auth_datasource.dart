import 'package:dio/dio.dart';
import 'package:flutrace_web/core/services/local_preferences.dart';
import 'package:flutrace_web/features/auth/data/models/user_model.dart';

abstract class AuthDatasource {
  Future<bool?> signIn({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUser();
  Future<void> clearTokens();
  Future<UserModel?> updateUser(Map<String, dynamic> fields);
}

class AuthDatasourceImpl extends AuthDatasource {
  AuthDatasourceImpl({required this.dio, required this.localStorage});

  final Dio dio;
  final LocalStorageService localStorage;

  @override
  Future<bool?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      'auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final accessToken = response.data['access_token'] as String;
    final refreshToken = response.data['refresh_token'] as String;
    final userId = response.data['user_id'] as int;

    await localStorage.setString('access_token', accessToken);
    await localStorage.setString('refresh_token', refreshToken);
    await localStorage.setInt('user_id', userId);

    return response.statusCode == 200;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await dio.get(
      'auth/me',
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future<void> clearTokens() async {
    await localStorage.remove('access_token');
    await localStorage.remove('refresh_token');
    await localStorage.remove('user_id');
  }

  @override
  Future<UserModel?> updateUser(Map<String, dynamic> fields) async {
    final response = await dio.patch(
      'auth/me',
      data: fields,
    );
    return UserModel.fromJson(response.data);
  }
}