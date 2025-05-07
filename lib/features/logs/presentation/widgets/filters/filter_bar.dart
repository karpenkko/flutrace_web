import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/features/logs/presentation/widgets/filters/filter_element.dart';
import 'package:flutrace_web/features/logs/presentation/widgets/filters/search_field.dart';
import 'package:flutter/material.dart';

class LogFiltersBar extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function(String?) onSearchChanged;
  final void Function(String?) onLevelChanged;
  final void Function(String?) onOSChanged;
  final void Function(String?) onEnvChanged;

  const LogFiltersBar({
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onLevelChanged,
    required this.onOSChanged,
    required this.onEnvChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SearchInput(
          controller: searchController,
          hintText: 'search',
          onChanged: onSearchChanged,
          focusNode: searchFocusNode,
        ),
        Row(
          children: [
            FilterElement(
              placeholder: 'all_levels',
              items: ['all_levels'.tr(), 'info', 'debug', 'warning', 'error', 'critical'],
              onChanged: onLevelChanged,
            ),
            const SizedBox(width: 10),
            FilterElement(
              placeholder: 'all_os',
              items: ['all_os'.tr(), 'Android', 'IOS'],
              onChanged: onOSChanged,
            ),
            const SizedBox(width: 10),
            FilterElement(
              placeholder: 'all_environments',
              items: ['all_environments'.tr(), 'dev', 'staging', 'prod'],
              onChanged: onEnvChanged,
            ),
          ],
        ),
      ],
    );
  }
}