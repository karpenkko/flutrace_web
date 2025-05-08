import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;

  const ErrorDisplay(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        margin: const EdgeInsets.symmetric(vertical: 60),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.tr(),
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: Theme.of(context).primaryColorLight,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
