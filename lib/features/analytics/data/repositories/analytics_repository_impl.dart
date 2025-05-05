import 'package:flutrace_web/core/error/failures.dart';
import 'package:flutrace_web/core/error/repository_request_handler.dart';
import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/analytics/data/datasource/analytics_datasource.dart';
import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';
import 'package:flutrace_web/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl extends AnalyticsRepository {
  final AnalyticsDatasource analyticsDatasource;

  AnalyticsRepositoryImpl({
    required this.analyticsDatasource,
  });

  @override
  FutureFailable<DashboardData> fetchDashboard(String projectId) {
    return RepositoryRequestHandler<DashboardData>()(
      request: () async {
        final result = await analyticsDatasource.fetchDashboard(projectId);
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }
}
