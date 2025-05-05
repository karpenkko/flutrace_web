import 'package:flutrace_web/core/error/failures.dart';
import 'package:flutrace_web/core/error/repository_request_handler.dart';
import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/logs/data/datasource/logs_datasource.dart';
import 'package:flutrace_web/features/logs/domain/entities/log_entity.dart';
import 'package:flutrace_web/features/logs/domain/repositories/logs_repository.dart';

class LogsRepositoryImpl extends LogsRepository {
  final LogsDatasource logsDatasource;

  LogsRepositoryImpl({
    required this.logsDatasource,
  });

  @override
  FutureFailable<List<LogEntity>> getLogsForProject({
    required String projectId,
    String? level,
    String? os,
    String? environment,
    String? search,
  }) {
    return RepositoryRequestHandler<List<LogEntity>>()(
      request: () async {
        final result = await logsDatasource.getLogsForProject(
          projectId: projectId,
          level: level,
          os: os,
          environment: environment,
          search: search,
        );
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }
}
