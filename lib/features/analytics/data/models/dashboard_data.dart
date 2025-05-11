class LogCountPoint {
  final String date;
  final int count;

  LogCountPoint({required this.date, required this.count});

  factory LogCountPoint.fromJson(Map<String, dynamic> json) =>
      LogCountPoint(date: json['date'], count: json['count']);
}

class LevelCount {
  final String level;
  final int count;

  LevelCount({required this.level, required this.count});

  factory LevelCount.fromJson(Map<String, dynamic> json) =>
      LevelCount(level: json['level'], count: json['count']);
}

class VersionErrorStat {
  final String version;
  final int errors;

  VersionErrorStat({required this.version, required this.errors});

  factory VersionErrorStat.fromJson(Map<String, dynamic> json) =>
      VersionErrorStat(
        version: json['version'],
        errors: json['errors'],
      );
}

class ComparisonStats {
  final double? yesterday;
  final double? lastWeek;

  ComparisonStats({this.yesterday, this.lastWeek});

  factory ComparisonStats.fromJson(Map<String, dynamic> json) =>
      ComparisonStats(
        yesterday: (json['yesterday'] as num?)?.toDouble(),
        lastWeek: (json['last_week'] as num?)?.toDouble(),
      );
}

class DashboardData {
  final int totalLogsToday;
  final int errorLogsToday;
  final int criticalLogsToday;
  final ComparisonStats comparison;
  final List<LogCountPoint> logCounts;
  final List<LevelCount> levelDistributionToday;
  final List<VersionErrorStat> topVersions;
  final DateTime? lastLogTimestamp;

  DashboardData({
    required this.totalLogsToday,
    required this.errorLogsToday,
    required this.criticalLogsToday,
    required this.comparison,
    required this.logCounts,
    required this.levelDistributionToday,
    required this.topVersions,
    this.lastLogTimestamp,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    totalLogsToday: json['total_logs_today'],
    errorLogsToday: json['error_logs_today'],
    criticalLogsToday: json['critical_logs_today'],
    comparison: ComparisonStats.fromJson(json['comparison']),
    logCounts: (json['log_counts'] as List)
        .map((e) => LogCountPoint.fromJson(e))
        .toList(),
    levelDistributionToday: (json['level_distribution_today'] as List)
        .map((e) => LevelCount.fromJson(e))
        .toList(),
    topVersions: (json['top_versions'] as List)
        .map((e) => VersionErrorStat.fromJson(e))
        .toList(),
    lastLogTimestamp: json['last_log_timestamp'] != null
        ? DateTime.parse(json['last_log_timestamp']).toLocal()
        : null,
  );
}
