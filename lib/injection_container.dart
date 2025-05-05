import 'package:dio/dio.dart';
import 'package:flutrace_web/features/projects/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/interceptors/error_logger_interceptor.dart';
import 'core/interceptors/token_interceptor.dart';
import 'core/network/network_info.dart';
import 'core/services/local_preferences.dart';
import 'features/analytics/injection_container.dart';
import 'features/auth/injection_container.dart';
import 'features/logs/injection_container.dart';
import 'features/theme/injection_container.dart';

final sl = GetIt.instance;

const globalDio = 'global';

class InjectionContainer extends Injector
    with
        AuthInjector,
        ThemeInjector,
        ProjectInjector,
        LogsInjector,
        AnalyticsInjector
{
  InjectionContainer();
}

abstract class Injector {
  @mustCallSuper
  Future<void> init() async {
    sl.registerLazySingleton<Dio>(
          () {
        final dio = Dio(BaseOptions(
          baseUrl: "http://127.0.0.1:8000/",
          connectTimeout: const Duration(milliseconds: 15000),
          receiveTimeout: const Duration(milliseconds: 15000),
        ));
        dio.options.headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
        };
        dio.interceptors.add(TokenInterceptor(localStorage: sl<LocalStorageService>()));
        dio.interceptors.add(ErrorLoggerInterceptor(
          dio: dio,
          localStorage: sl<LocalStorageService>(),
        ));
        dio.interceptors.add(PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
        ));
        return dio;
      },
      instanceName: globalDio,
    );

    // Core
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

    // External
    sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService(sl()));
  }
}
