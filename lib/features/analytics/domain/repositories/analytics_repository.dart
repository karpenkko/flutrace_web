import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/analytics/data/models/analytics_data.dart';
import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';

abstract class AnalyticsRepository{
  FutureFailable<DashboardData> fetchDashboard(String projectId);
  FutureFailable<List<TimePoint>> getLogsCount(String projectId, String interval);
  FutureFailable<AnalyticsSummary> getSummary(String projectId);
}