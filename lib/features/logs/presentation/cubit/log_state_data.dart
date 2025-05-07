import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/logs/domain/entities/detailed_log_entity.dart';
import 'package:flutrace_web/features/logs/domain/entities/log_entity.dart';

class LogsStateData extends Equatable {
  final List<LogEntity> logs;
  final DetailedLogEntity? selectedLog;
  final bool isJsonView;

  const LogsStateData({
    required this.logs,
    this.selectedLog,
    this.isJsonView = false,
  });

  factory LogsStateData.init() => const LogsStateData(
    logs: [],
    selectedLog: null,
    isJsonView: false,
  );

  LogsStateData copyWith({
    List<LogEntity>? logs,
    DetailedLogEntity? selectedLog,
    bool? isJsonView,
  }) {
    return LogsStateData(
      logs: logs ?? this.logs,
      selectedLog: selectedLog ?? this.selectedLog,
      isJsonView: isJsonView ?? this.isJsonView,
    );
  }

  @override
  List<Object?> get props => [logs, selectedLog ?? '', isJsonView];
}