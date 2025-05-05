import 'package:flutrace_web/core/error/failures.dart';
import 'package:flutrace_web/core/error/repository_request_handler.dart';
import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/theme/data/datasource/theme_local_datasource.dart';
import 'package:flutrace_web/features/theme/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl extends ThemeRepository {
  ThemeRepositoryImpl({
    required this.localDatasource,
  });

  final ThemeLocalDatasource localDatasource;

  @override
  FutureFailable<void> setTheme(String theme) {
    return RepositoryRequestHandler<void>()(
      request: () async {
        await localDatasource.setTheme(theme);
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<String?> getTheme() {
    return RepositoryRequestHandler<String?>()(
      request: () async {
        final result = await localDatasource.getTheme();
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<void> setLanguage(String lang) {
    return RepositoryRequestHandler<void>()(
      request: () async {
        await localDatasource.setLanguage(lang);
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<String?> getLanguage() {
    return RepositoryRequestHandler<String?>()(
      request: () async {
        final result = await localDatasource.getLanguage();
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }
}
