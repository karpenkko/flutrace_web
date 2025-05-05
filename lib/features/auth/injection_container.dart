import 'package:dio/dio.dart';
import 'package:flutrace_web/core/services/local_preferences.dart';
import 'package:flutrace_web/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutrace_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutrace_web/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutrace_web/features/auth/presentation/cubits/user_cubit.dart';
import 'package:flutrace_web/injection_container.dart';

import 'data/datasource/auth_datasource.dart';

mixin AuthInjector on Injector{

  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    sl.registerFactory(() => AuthCubit(repository: sl()));
    sl.registerLazySingleton(() => UserCubit(repository: sl()));

    // repositories
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      datasource: sl(),
    ));

    // data sources
    sl.registerLazySingleton<AuthDatasource>(
          () => AuthDatasourceImpl(
        dio: dio,
        localStorage: sl<LocalStorageService>(),
      ),
    );
  }
}