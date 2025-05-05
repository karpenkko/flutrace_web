import 'package:flutrace_web/features/logs/data/datasource/logs_datasource.dart';
import 'package:flutrace_web/features/logs/domain/repositories/logs_repository.dart';
import 'package:flutrace_web/features/logs/data/repositories/logs_repository_impl.dart';
import 'package:flutrace_web/features/logs/presentation/cubit/log_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:dio/dio.dart';

mixin LogsInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // cubits
    sl.registerFactory(() => LogsCubit(repository: sl()));

    // repositories
    sl.registerLazySingleton<LogsRepository>(() => LogsRepositoryImpl(logsDatasource: sl(),));

    // data sources
    sl.registerLazySingleton<LogsDatasource>(() => LogsDatasourceImpl(dio: dio));

    // use case

  }
}
