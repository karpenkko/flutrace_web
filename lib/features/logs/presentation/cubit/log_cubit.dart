import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/logs/domain/repositories/logs_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'log_state_data.dart';

part 'log_state.dart';

class LogsCubit extends Cubit<LogsState> {
  final LogsRepository _repository;

  LogsCubit({required LogsRepository repository})
      : _repository = repository,
        super(LogsInitial(stateData: LogsStateData.init()));

  LogsStateData get _data => state.stateData;

  Future<void> fetchLogs(
      String projectId, {
        String? level,
        String? os,
        String? environment,
        String? search,
        DateTime? cursor,
        bool append = false,
      }) async {
    if (!append) emit(LogsLoading(stateData: _data));

    final result = await _repository.getLogsForProject(
      projectId: projectId,
      level: level,
      os: os,
      environment: environment,
      search: search,
      cursor: cursor,
    );

    result.fold(
          (failure) => emit(LogsError(message: failure.errorMessage, stateData: _data)),
          (logs) {
        final updatedLogs = append ? [..._data.logs, ...logs] : logs;
        emit(LogsLoaded(stateData: _data.copyWith(logs: updatedLogs)));
      },
    );
  }


  Future<void> fetchLogDetail(String projectId, int logId) async {
    emit(LogsLoading(stateData: _data));
    final result = await _repository.getLogDetail(projectId, logId);

    result.fold(
          (failure) => emit(LogsError(message: failure.errorMessage, stateData: _data)),
          (log) => emit(LogDetailLoaded(stateData: _data.copyWith(selectedLog: log))),
    );
  }

  void clearSelectedLog() {
    emit(LogsLoaded(stateData:_data.copyWith(selectedLog: null, isJsonView: false)));
  }

  void toggleJsonView() {
    emit(LogDetailLoaded(stateData: _data.copyWith(isJsonView: !_data.isJsonView)));
  }
}
