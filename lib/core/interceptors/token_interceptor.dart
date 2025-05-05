import 'package:dio/dio.dart';
import 'package:flutrace_web/core/services/local_preferences.dart';

class TokenInterceptor extends Interceptor {
  final LocalStorageService localStorage;

  TokenInterceptor({required this.localStorage});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.path.contains('/auth/login') && !options.path.contains('/auth/refresh')) {
      final accessToken = localStorage.getString('access_token');
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      } else {
      }
    }
    super.onRequest(options, handler);
  }
}
