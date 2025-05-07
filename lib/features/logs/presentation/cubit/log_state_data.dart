import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/logs/domain/entities/detailed_log_entity.dart';
import 'package:flutrace_web/features/logs/domain/entities/log_entity.dart';

class LogsStateData extends Equatable {
  final List<LogEntity> logs;
  final DetailedLogEntity? selectedLog;
  final bool isJsonView;
  final DateTime? cursor;

  const LogsStateData({
    required this.logs,
    this.selectedLog,
    this.isJsonView = false,
    this.cursor,
  });

  factory LogsStateData.init() => const LogsStateData(
    logs: [],
    selectedLog: null,
    isJsonView: false,
    cursor: null,
  );

  LogsStateData copyWith({
    List<LogEntity>? logs,
    DetailedLogEntity? selectedLog,
    bool? isJsonView,
    DateTime? cursor,
  }) {
    return LogsStateData(
      logs: logs ?? this.logs,
      selectedLog: selectedLog ?? this.selectedLog,
      isJsonView: isJsonView ?? this.isJsonView,
      cursor: cursor ?? this.cursor,
    );
  }

  @override
  List<Object?> get props => [logs, selectedLog ?? '', isJsonView, cursor];
}