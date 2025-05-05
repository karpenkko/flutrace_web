import 'package:flutrace_web/core/services/local_preferences.dart';
import 'package:flutrace_web/features/theme/presentation/cubit/lang_cubit.dart';
import 'package:flutrace_web/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutrace_web/injection_container.dart';

import 'data/datasource/theme_local_datasource.dart';
import 'data/repositories/theme_repository_impl.dart';
import 'domain/repositories/theme_repository.dart';

mixin ThemeInjector on Injector{

  @override
  Future<void> init() async {
    await super.init();

    sl.registerLazySingleton(() => ThemeCubit(repository: sl()));
    sl.registerLazySingleton(() => LanguageCubit(repository: sl()));

    // repositories
    sl.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(
      localDatasource: sl(),
    ));

    // data sources
    sl.registerLazySingleton<ThemeLocalDatasource>(
          () => ThemeLocalDatasourceImpl(
        localStorage: sl<LocalStorageService>(),
      ),
    );
  }
}