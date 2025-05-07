import 'package:equatable/equatable.dart';

class DetailedLogEntity extends Equatable {
  final int id;
  final String message;
  final String level;
  final DateTime timestamp;
  final String token;
  final String? environment;
  final Map<String, dynamic>? device;
  final Map<String, dynamic>? error;
  final Map<String, dynamic>? custom;

  const DetailedLogEntity({
    required this.id,
    required this.message,
    required this.level,
    required this.timestamp,
    required this.token,
    this.environment,
    this.device,
    this.error,
    this.custom,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'level': level,
      'timestamp': timestamp.toIso8601String(),
      'token': token,
      'environment': environment,
      'device': device,
      'error': error,
      'custom': custom,
    };
  }

  @override
  List<Object?> get props => [
    id,
    message,
    level,
    timestamp,
    token,
    environment,
    device,
    error,
    custom,
  ];
}
