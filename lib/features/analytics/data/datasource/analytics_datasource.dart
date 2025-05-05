import 'package:dio/dio.dart';
import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';

abstract class AnalyticsDatasource {
  Future<DashboardData> fetchDashboard(String projectId);
}

class AnalyticsDatasourceImpl extends AnalyticsDatasource {
  AnalyticsDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<DashboardData> fetchDashboard(String projectId) async {
    final response = await dio.get('/projects/$projectId/dashboard');
    return DashboardData.fromJson(response.data);
  }
}