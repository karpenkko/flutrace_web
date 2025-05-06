import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/analytics/data/models/analytics_data.dart';

class AnalyticsStateData extends Equatable {
  final List<TimePoint> logsCount;
  final String interval;
  final AnalyticsSummary? summary;

  const AnalyticsStateData({
    required this.logsCount,
    required this.interval,
    this.summary,
  });

  factory AnalyticsStateData.init() => const AnalyticsStateData(
    logsCount: [],
    interval: 'day',
    summary: null,
  );

  AnalyticsStateData copyWith({
    List<TimePoint>? logsCount,
    String? interval,
    AnalyticsSummary? summary,
  }) {
    return AnalyticsStateData(
      logsCount: logsCount ?? this.logsCount,
      interval: interval ?? this.interval,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [logsCount, interval, summary];
}
