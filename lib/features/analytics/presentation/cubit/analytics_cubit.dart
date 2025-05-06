import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/analytics/data/models/analytics_data.dart';
import 'package:flutrace_web/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'analytics_state_data.dart';
part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsCubit({required AnalyticsRepository repository})
      : _repository = repository,
        super(AnalyticsInitial(stateData: AnalyticsStateData.init()));

  AnalyticsStateData get _data => state.stateData;

  Future<void> fetchLogsCount(String projectId, String interval) async {
    final response = await _repository.getLogsCount(projectId, interval);
    response.fold(
          (error) {
        emit(AnalyticsError(message: "Помилка: $error", stateData: _data));
      },
          (logs) {
        final updated = _data.copyWith(logsCount: logs, interval: interval);
        emit(AnalyticsLoaded(stateData: updated));
      },
    );
  }

  Future<void> fetchSummary(String projectId) async {
    final response = await _repository.getSummary(projectId);
    response.fold(
          (error) {
        emit(AnalyticsError(message: "Помилка: $error", stateData: _data));
      },
          (summary) {
        final updated = _data.copyWith(summary: summary);
        emit(AnalyticsLoaded(stateData: updated));
      },
    );
  }

  Future<void> fetchAll(String projectId, {String interval = 'day'}) async {
    emit(AnalyticsLoading(stateData: _data));

    final logsRes = await _repository.getLogsCount(projectId, interval);
    final summaryRes = await _repository.getSummary(projectId);

    logsRes.fold(
          (logError) => emit(AnalyticsError(message: "Помилка логів: $logError", stateData: _data)),
          (logs) {
        summaryRes.fold(
              (sumError) => emit(AnalyticsError(message: "Помилка аналітики: $sumError", stateData: _data)),
              (summary) {
            final updated = _data.copyWith(logsCount: logs, interval: interval, summary: summary);
            emit(AnalyticsLoaded(stateData: updated));
          },
        );
      },
    );
  }
}
