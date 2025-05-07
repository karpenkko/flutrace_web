import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/logs/data/models/log_model.dart';
import 'package:flutrace_web/features/logs/domain/repositories/logs_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html';
import 'log_state_data.dart';
part 'log_state.dart';

class LogsCubit extends Cubit<LogsState> {
  final LogsRepository _repository;

  LogsCubit({required LogsRepository repository})
      : _repository = repository,
        super(LogsInitial(stateData: LogsStateData.init()));

  LogsStateData get _data => state.stateData;

  EventSource? _eventSource;
  bool _isFetching = false;

  Future<void> fetchLogs(
    String projectId, {
    String? level,
    String? os,
    String? environment,
    String? search,
    DateTime? cursor,
    bool append = false,
  }) async {
    if (_isFetching) return;
    _isFetching = true;

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
      (failure) =>
          emit(LogsError(message: failure.errorMessage, stateData: _data)),
      (logs) {
        final updatedLogs = append ? [..._data.logs, ...logs] : logs;
        final newCursor =
            updatedLogs.isNotEmpty ? updatedLogs.last.appeared : null;
        emit(LogsLoaded(
            stateData: _data.copyWith(logs: updatedLogs, cursor: newCursor)));
      },
    );
    _isFetching = false;
  }

  Future<void> fetchLogDetail(String projectId, int logId) async {
    emit(LogsLoading(stateData: _data));
    final result = await _repository.getLogDetail(projectId, logId);

    result.fold(
      (failure) =>
          emit(LogsError(message: failure.errorMessage, stateData: _data)),
      (log) =>
          emit(LogDetailLoaded(stateData: _data.copyWith(selectedLog: log))),
    );
  }

  void clearSelectedLog() {
    emit(LogsLoaded(
        stateData: _data.copyWith(selectedLog: null, isJsonView: false)));
  }

  void toggleJsonView() {
    emit(LogDetailLoaded(
        stateData: _data.copyWith(isJsonView: !_data.isJsonView)));
  }

  void startSSE(String projectId) {
    stopSSE();

    final uri = Uri.parse('http://localhost:8000/logs/stream/$projectId');
    _eventSource = EventSource(uri.toString());

    _eventSource!.onMessage.listen((event) {
      final data = event.data;
      try {
        final json = jsonDecode(data);
        final log = LogModel.fromJson(json);
        final currentLogs = _data.logs;



        if (!currentLogs.any((e) => e.id == log.id)) {
          final updated = [log, ...currentLogs];
          emit(LogsLoaded(stateData: _data.copyWith(logs: updated)));
        }
      } catch (e) {
        print('Failed to parse SSE data: $e');
      }
    });
  }

  void stopSSE() {
    _eventSource?.close();
    _eventSource = null;
  }

  @override
  Future<void> close() {
    stopSSE();
    return super.close();
  }
}
