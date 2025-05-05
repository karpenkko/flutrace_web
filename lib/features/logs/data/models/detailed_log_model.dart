import 'package:flutrace_web/features/logs/domain/entities/detailed_log_entity.dart';

class DetailedLogModel extends DetailedLogEntity {
  const DetailedLogModel({
    required super.id,
    required super.message,
    required super.level,
    required super.timestamp,
    required super.token,
    super.environment,
    super.device,
    super.error,
    super.custom,
  });

  factory DetailedLogModel.fromJson(Map<String, dynamic> json) {
    return DetailedLogModel(
      id: json['id'],
      message: json['message'],
      level: json['level'],
      timestamp: DateTime.parse(json['timestamp']),
      token: json['token'],
      environment: json['environment'],
      device: json['device'],
      error: json['error'],
      custom: json['custom'],
    );
  }
}
