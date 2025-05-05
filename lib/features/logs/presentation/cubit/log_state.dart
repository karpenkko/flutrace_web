part of 'log_cubit.dart';

abstract class LogsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogsInitial extends LogsState {}

class LogsLoading extends LogsState {}

class LogsLoaded extends LogsState {
  final List<LogEntity> logs;
  LogsLoaded(this.logs);

  @override
  List<Object?> get props => [logs];
}

class LogsError extends LogsState {
  final String message;
  LogsError(this.message);

  @override
  List<Object?> get props => [message];
}