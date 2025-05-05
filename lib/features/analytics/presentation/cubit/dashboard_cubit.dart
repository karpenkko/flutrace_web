import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';
import 'package:flutrace_web/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AnalyticsRepository _repository;

  DashboardCubit({required AnalyticsRepository repository})
      : _repository = repository,
        super(DashboardLoading());

  Future<void> loadDashboard(String projectId) async {
    final response = await _repository.fetchDashboard(projectId);
    response.fold(
      (failure) => emit(
        DashboardError(
            "Не вдалося завантажити дашборд: ${failure.errorMessage}"),
      ),
      (data) => emit(DashboardLoaded(data)),
    );
  }
}
