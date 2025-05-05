import 'package:flutrace_web/features/analytics/data/datasource/analytics_datasource.dart';
import 'package:flutrace_web/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:flutrace_web/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:flutrace_web/features/analytics/presentation/cubit/dashboard_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:dio/dio.dart';

mixin AnalyticsInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // cubits
    sl.registerFactory(() => DashboardCubit(repository: sl()));

    // repositories
    sl.registerLazySingleton<AnalyticsRepository>(() => AnalyticsRepositoryImpl(analyticsDatasource: sl(),));

    // data sources
    sl.registerLazySingleton<AnalyticsDatasource>(() => AnalyticsDatasourceImpl(dio: dio));

    // use case

  }
}
