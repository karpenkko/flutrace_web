class TimePoint {
  final String label;
  final int count;
  final DateTime timestamp;

  TimePoint({
    required this.label,
    required this.count,
    required this.timestamp,
  });

  factory TimePoint.fromJson(Map<String, dynamic> json) {
    return TimePoint(
      label: json['label'],
      count: json['count'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}


class OSStat {
  final String os;
  final int count;

  OSStat({required this.os, required this.count});

  factory OSStat.fromJson(Map<String, dynamic> json) =>
      OSStat(os: json['os'], count: json['count']);
}

class DeviceStat {
  final String model;
  final int count;

  DeviceStat({required this.model, required this.count});

  factory DeviceStat.fromJson(Map<String, dynamic> json) =>
      DeviceStat(model: json['model'], count: json['count']);
}

class MessageStat {
  final String message;
  final int count;

  MessageStat({required this.message, required this.count});

  factory MessageStat.fromJson(Map<String, dynamic> json) =>
      MessageStat(message: json['message'], count: json['count']);
}

class CountryStat {
  final String country;
  final int count;

  CountryStat({required this.country, required this.count});

  factory CountryStat.fromJson(Map<String, dynamic> json) =>
      CountryStat(country: json['country'], count: json['count']);
}

class AnalyticsSummary {
  final List<OSStat> osDistribution;
  final List<DeviceStat> topDevices;
  final List<MessageStat> topMessages;
  final List<CountryStat> errorsByCountry;

  AnalyticsSummary({
    required this.osDistribution,
    required this.topDevices,
    required this.topMessages,
    required this.errorsByCountry,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) =>
      AnalyticsSummary(
        osDistribution: (json['os_distribution'] as List)
            .map((e) => OSStat.fromJson(e))
            .toList(),
        topDevices: (json['top_devices'] as List)
            .map((e) => DeviceStat.fromJson(e))
            .toList(),
        topMessages: (json['top_messages'] as List)
            .map((e) => MessageStat.fromJson(e))
            .toList(),
        errorsByCountry: (json['errors_by_country'] as List)
            .map((e) => CountryStat.fromJson(e))
            .toList(),
      );
}

