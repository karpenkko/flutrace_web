import 'package:flutrace_web/core/error/failures.dart';
import 'package:flutrace_web/core/error/repository_request_handler.dart';
import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/logs/data/datasource/logs_datasource.dart';
import 'package:flutrace_web/features/logs/domain/entities/detailed_log_entity.dart';
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
    DateTime? cursor
  }) {
    return RepositoryRequestHandler<List<LogEntity>>()(
      request: () async {
        final result = await logsDatasource.getLogsForProject(
          projectId: projectId,
          level: level,
          os: os,
          environment: environment,
          search: search,
          cursor: cursor,
        );
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<DetailedLogEntity> getLogDetail(String projectId, int logId) {
    return RepositoryRequestHandler<DetailedLogEntity>()(
      request: () async {
        final result = await logsDatasource.getLogDetail(projectId, logId);
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }
}
