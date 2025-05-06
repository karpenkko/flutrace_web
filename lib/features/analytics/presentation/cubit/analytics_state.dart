part of 'analytics_cubit.dart';

abstract class AnalyticsState extends Equatable {
  final AnalyticsStateData stateData;

  const AnalyticsState({required this.stateData});

  @override
  List<Object?> get props => [stateData];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial({required super.stateData});
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading({required super.stateData});
}

class AnalyticsLoaded extends AnalyticsState {
  const AnalyticsLoaded({required super.stateData});
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError({required this.message, required super.stateData});

  @override
  List<Object?> get props => [message, stateData];
}
