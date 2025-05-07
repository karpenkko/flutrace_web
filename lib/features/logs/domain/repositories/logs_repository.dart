
import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/logs/domain/entities/detailed_log_entity.dart';
import 'package:flutrace_web/features/logs/domain/entities/log_entity.dart';

abstract class LogsRepository{
  FutureFailable<List<LogEntity>> getLogsForProject({
    required String projectId,
    String? level,
    String? os,
    String? environment,
    String? search,
    DateTime? cursor,
  });

  FutureFailable<DetailedLogEntity> getLogDetail(String projectId, int logId);
}