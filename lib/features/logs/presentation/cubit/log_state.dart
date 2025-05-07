part of 'log_cubit.dart';

abstract class LogsState extends Equatable {
  final LogsStateData stateData;

  const LogsState({required this.stateData});

  @override
  List<Object?> get props => [stateData];
}

class LogsInitial extends LogsState {
  const LogsInitial({required super.stateData});
}

class LogsLoading extends LogsState {
  const LogsLoading({required super.stateData});
}

class LogsLoaded extends LogsState {
  const LogsLoaded({required super.stateData});
}

class LogDetailLoaded extends LogsState {
  const LogDetailLoaded({required super.stateData});
}

class LogsError extends LogsState {
  final String message;

  const LogsError({required this.message, required super.stateData});

  @override
  List<Object?> get props => [message, stateData];
}