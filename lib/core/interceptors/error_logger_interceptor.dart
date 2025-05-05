import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:flutrace_web/core/services/local_preferences.dart';

class ErrorLoggerInterceptor extends Interceptor {
  final Dio dio;
  final LocalStorageService localStorage;

  ErrorLoggerInterceptor({required this.dio, required this.localStorage});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    Fimber.e('---------------- Error Logger Interceptor ----------------');

    if (err.response == null) {
      Fimber.e('Error: no response in error - $err');
      return super.onError(err, handler);
    }

    if (err.response!.statusCode == 401) {
      Fimber.e('Error: 401 Unauthorized - trying to refresh token');

      final refreshToken = localStorage.getString('refresh_token');

      if (refreshToken != null) {
        try {
          final refreshResponse = await dio.post(
            '/auth/refresh',
            queryParameters: {'refresh_token': refreshToken},
          );

          final newAccessToken = refreshResponse.data['access_token'] as String;
          final newRefreshToken = refreshResponse.data['refresh_token'] as String;

          await localStorage.setString('access_token', newAccessToken);
          await localStorage.setString('refresh_token', newRefreshToken);

          final clonedRequest = await dio.fetch(
            err.requestOptions..headers['Authorization'] = 'Bearer $newAccessToken',
          );
          return handler.resolve(clonedRequest);
        } catch (refreshError) {
          Fimber.e('Token refresh failed: $refreshError');
          await localStorage.remove('access_token');
          await localStorage.remove('refresh_token');
          return handler.reject(err);
        }
      } else {
        Fimber.e('No refresh token available');
        return handler.reject(err);
      }
    }

    if (err.response!.data is Map<String, dynamic> &&
        err.response!.data.containsKey('data')) {
      err.response!.data = err.response!.data['data'];
    }

    if (err.response!.statusCode == 400) {
      final data = err.response!.data;
      if (data.isNotEmpty && data is Map<String, dynamic>) {
        final keys = data.keys;
        for (final key in keys) {
          Fimber.e('$key - ${err.response!.data[key].toString()}');
        }
      } else {
        Fimber.e('Error: no body in error response - $err');
      }
    }

    return super.onError(err, handler);
  }
}
