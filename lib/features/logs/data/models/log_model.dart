import 'package:flutrace_web/features/logs/domain/entities/log_entity.dart';

class LogModel extends LogEntity {
  const LogModel({
    required super.id,
    required super.projectId,
    required super.message,
    required super.level,
    super.os,
    required super.environment,
    required super.appeared,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    final device = json['device'];
    final os = device != null && device['platform'] != null ? device['platform'] as String : null;

    return LogModel(
      id: json['id'],
      projectId: json['token'],
      message: json['message'],
      level: json['level'],
      os: os,
      environment: json['environment'],
      appeared: DateTime.parse(json['timestamp']),
    );
  }
}

