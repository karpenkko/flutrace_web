import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutter/material.dart';

class JsonToggleSwitch extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onChanged;

  const JsonToggleSwitch({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'log_detail.json'.tr(),
            style: AppTextStyles.body(context),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 46,
            height: 26,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
              isEnabled ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).primaryColorLight,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
