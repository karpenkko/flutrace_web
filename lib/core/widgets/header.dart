import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutter/material.dart';
import 'header_actions.dart';
import 'logo.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.isFull,
    this.projectName = 'project_name',
  });

  final bool isFull;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isFull ? const EdgeInsets.symmetric(horizontal: 60, vertical: 20) : const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isFull ? const Logo() : Text('projects / ${projectName.toLowerCase()}', style: AppTextStyles.body(context)),
          const HeaderActions(),
        ],
      ),
    );
  }
}
