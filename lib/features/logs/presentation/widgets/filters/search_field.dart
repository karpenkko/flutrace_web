import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutrace_web/core/styles/font.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const SearchInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440,
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          cursorColor: Theme.of(context).colorScheme.surface,
          style: AppTextStyles.searchField(context),
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            hintText: hintText.tr(),
            hintStyle: AppTextStyles.searchField(context).copyWith(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
