import 'package:dio/dio.dart';
import 'package:flutrace_web/features/analytics/data/models/analytics_data.dart';
import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';

abstract class AnalyticsDatasource {
  Future<DashboardData> fetchDashboard(String projectId);
  Future<List<TimePoint>> getLogsCount(String projectId, String interval);
  Future<AnalyticsSummary> getSummary(String projectId);
}

class AnalyticsDatasourceImpl extends AnalyticsDatasource {
  AnalyticsDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<DashboardData> fetchDashboard(String projectId) async {
    final response = await dio.get('/projects/$projectId/dashboard');
    return DashboardData.fromJson(response.data);
  }

  @override
  Future<List<TimePoint>> getLogsCount(String projectId, String interval) async {
    final res = await dio.get('/projects/$projectId/analytics/logs_count', queryParameters: {
      'interval': interval,
    });

    return (res.data as List)
        .map((json) => TimePoint.fromJson(json))
        .toList();
  }

  @override
  Future<AnalyticsSummary> getSummary(String projectId) async {
    final res = await dio.get('/projects/$projectId/analytics/summary');

    return AnalyticsSummary.fromJson(res.data);
  }
}