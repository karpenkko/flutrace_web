import 'package:dio/dio.dart';
import 'package:flutrace_web/features/logs/data/models/log_model.dart';

abstract class LogsDatasource {
  Future<List<LogModel>> getLogsForProject({
    required String projectId,
    String? level,
    String? os,
    String? environment,
    String? search,
  });
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
  }) async {
    final response = await dio.get(
      'logs/$projectId',
      queryParameters: {
        if (level != null) 'level': level,
        if (os != null) 'os': os,
        if (environment != null) 'environment': environment,
        if (search != null) 'search': search,
      },
    );
    final List<dynamic> data = response.data;
    return data.map((log) => LogModel.fromJson(log)).toList();
  }
}
