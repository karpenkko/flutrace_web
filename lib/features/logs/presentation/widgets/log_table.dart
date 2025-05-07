import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/features/logs/domain/entities/log_entity.dart';
import 'package:flutter/material.dart';

class LogTable extends StatelessWidget {
  final List<LogEntity> logs ;
  final ValueChanged<int>? onTap;

  const LogTable({
    super.key,
    required this.logs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        children: [
          _LogRow(
            isHeader: true,
            message: 'error_message'.tr(),
            level: 'level'.tr(),
            os: 'os'.tr(),
            environment: 'environment'.tr(),
            appeared: 'appeared'.tr(),
          ),
          Divider(height: 24, color: Theme.of(context).cardColor,),
          ...logs.map((log) => _LogRow(
            message: log.message,
            level: log.level,
            os: log.os,
            environment: log.environment,
            appeared: log.timeAgo,
            onTap: () => onTap?.call(log.id),
          )),
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  final String message;
  final String level;
  final String? os;
  final String environment;
  final String appeared;
  final bool isHeader;
  final VoidCallback? onTap;

  const _LogRow({
    required this.message,
    required this.level,
    required this.os,
    required this.environment,
    required this.appeared,
    this.isHeader = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = isHeader
        ? AppTextStyles.searchField(context)
        : AppTextStyles.body(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(message, style: isHeader ? style : style.copyWith(fontWeight: FontWeight.w600)),
            ),
            Expanded(flex: 1, child: Text(level, style: style)),
            Expanded(flex: 1, child: Text(os ?? 'null', style: style)),
            Expanded(flex: 1, child: Text(environment, style: style)),
            Expanded(flex: 1, child: Text(appeared, style: style)),
          ],
        ),
      ),
    );
  }
}

