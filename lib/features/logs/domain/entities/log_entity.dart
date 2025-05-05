import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

class LogEntity extends Equatable {
  final int id;
  final String projectId;
  final String message;
  final String level;
  final String? os;
  final String environment;
  final DateTime appeared;

  const LogEntity({
    required this.id,
    required this.projectId,
    required this.message,
    required this.level,
    this.os,
    required this.environment,
    required this.appeared,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        message,
        level,
        os,
        environment,
        appeared,
      ];
}

extension LogTimeAgo on LogEntity {
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(appeared);

    if (diff.inMinutes < 1) return 'just_now'.tr();
    if (diff.inMinutes < 60) return 'minutes_ago'.tr(args: ['${diff.inMinutes}']);
    if (diff.inHours < 24) return 'hours_ago'.tr(args: ['${diff.inHours}']);
    return 'days_ago'.tr(args: ['${diff.inDays}']);
  }
}
