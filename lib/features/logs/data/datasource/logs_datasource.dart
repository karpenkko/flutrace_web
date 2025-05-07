import 'package:dio/dio.dart';
import 'package:flutrace_web/features/logs/data/models/detailed_log_model.dart';
import 'package:flutrace_web/features/logs/data/models/log_model.dart';

abstract class LogsDatasource {
  Future<List<LogModel>> getLogsForProject({
    required String projectId,
    String? level,
    String? os,
    String? environment,
    String? search,
    DateTime? cursor
  });
  Future<DetailedLogModel> getLogDetail(String projectId, int logId);
}

class LogsDatasourceImpl extends LogsDatasource {
  LogsDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<LogModel>> getLogsForProject({
    required String projectId,
    String? level,
    String? os,
    String? environment,
    String? search,
    DateTime? cursor
  }) async {
    final response = await dio.get(
      'logs/$projectId',
      queryParameters: {
        if (level != null) 'level': level,
        if (os != null) 'os': os,
        if (environment != null) 'environment': environment,
        if (search != null) 'search': search,
        if (cursor != null) 'before': cursor.toIso8601String(),
      },
    );
    final List<dynamic> data = response.data;
    return data.map((log) => LogModel.fromJson(log)).toList();
  }

  @override
  Future<DetailedLogModel> getLogDetail(String projectId, int logId) async {
    final response = await dio.get('logs/$projectId/$logId');
    return DetailedLogModel.fromJson(response.data);
  }
}
