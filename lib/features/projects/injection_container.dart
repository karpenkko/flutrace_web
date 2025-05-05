import 'package:dio/dio.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/injection_container.dart';

import 'data/datasource/project_datasource.dart';
import 'data/repositories/project_repository_impl.dart';
import 'domain/repositories/project_repository.dart';

mixin ProjectInjector on Injector{

  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    sl.registerLazySingleton(() => ProjectCubit(repository: sl()));

    // repositories
    sl.registerLazySingleton<ProjectRepository>(() => ProjectRepositoryImpl(
      datasource: sl(),
    ));

    // data sources
    sl.registerLazySingleton<ProjectDatasource>(
          () => ProjectDatasourceImpl(
        dio: dio,
      ),
    );
  }
}