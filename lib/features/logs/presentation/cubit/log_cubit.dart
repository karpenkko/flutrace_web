import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/logs/domain/entities/detailed_log_entity.dart';
import 'package:flutrace_web/features/logs/domain/entities/log_entity.dart';
import 'package:flutrace_web/features/logs/domain/repositories/logs_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_state.dart';

class LogsCubit extends Cubit<LogsState> {
  final LogsRepository _repository;

  LogsCubit({required LogsRepository repository})
      : _repository = repository,
        super(LogsInitial());

  Future<void> fetchLogs(
      String projectId, {
        String? level,
        String? os,
        String? environment,
        String? search,
      }) async {
    emit(LogsLoading());
    final result = await _repository.getLogsForProject(
      projectId: projectId,
      level: level,
      os: os,
      environment: environment,
      search: search,
    );

    result.fold(
          (failure) => emit(LogsError(failure.errorMessage)),
          (logs) => emit(LogsLoaded(logs)),
    );
  }
}
