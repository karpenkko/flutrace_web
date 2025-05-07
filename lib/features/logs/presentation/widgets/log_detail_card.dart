import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/features/logs/domain/entities/detailed_log_entity.dart';
import 'package:flutrace_web/features/logs/presentation/widgets/switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutter/services.dart';

class LogDetailCard extends StatefulWidget {
  final DetailedLogEntity log;
  final VoidCallback onBack;
  final bool isJsonView;
  final VoidCallback onToggleJson;

  const LogDetailCard({
    super.key,
    required this.log,
    required this.onBack,
    required this.isJsonView,
    required this.onToggleJson,
  });

  @override
  State<LogDetailCard> createState() => _LogDetailCardState();
}

class _LogDetailCardState extends State<LogDetailCard> {
  bool _isCopied = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _copyCode() {
    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(widget.log.toJson());
    Clipboard.setData(ClipboardData(text: prettyJson));
    setState(() => _isCopied = true);

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isCopied = false);
      }
    });
  }

  Widget _buildItem(BuildContext context, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$title: ',
            style: AppTextStyles.headingMedium(context).copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '—',
              style: AppTextStyles.bodyMedium(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxedSection(
    BuildContext context,
    String title,
    Map<String, dynamic>? data,
  ) {
    if (data == null || data.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.surface, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headingMedium(context)),
          const SizedBox(height: 12),
          ...data.entries.map(
            (entry) => _buildItem(context, entry.key, entry.value.toString()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text('log_detail.back'.tr(),
                            style: AppTextStyles.body(context)
                                .copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                JsonToggleSwitch(
                  isEnabled: widget.isJsonView,
                  onChanged: widget.onToggleJson,
                ),
              ],
            ),
            const SizedBox(height: 30),

            if (widget.isJsonView)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      const JsonEncoder.withIndent('  ')
                          .convert(widget.log.toJson()),
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 24,
                    right: 24,
                    child: GestureDetector(
                      onTap: _copyCode,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          _isCopied ? Icons.check : Icons.copy,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('log_detail.log_details'.tr(),
                              style: AppTextStyles.headingMedium(context)),
                          const SizedBox(height: 12),
                          _buildItem(context, 'ID', widget.log.id.toString()),
                          _buildItem(context, 'Message', widget.log.message),
                          _buildItem(context, 'Level', widget.log.level),
                          _buildItem(
                              context, 'Environment', widget.log.environment),
                          _buildItem(
                            context,
                            'Timestamp',
                            DateFormat.yMd()
                                .add_Hm()
                                .format(widget.log.timestamp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildBoxedSection(
                        context, 'log_detail.device'.tr(), widget.log.device),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildBoxedSection(
                        context, 'log_detail.error'.tr(), widget.log.error),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildBoxedSection(
                        context, 'log_detail.custom'.tr(), widget.log.custom),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
