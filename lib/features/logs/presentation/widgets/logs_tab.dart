import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/features/logs/presentation/cubit/log_cubit.dart';
import 'package:flutrace_web/features/logs/presentation/widgets/log_table.dart';
import 'package:flutrace_web/features/logs/presentation/widgets/search_field.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_element.dart';

class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends State<LogsTab> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late LogsCubit _logsCubit;
  Timer? _debounce;

  String? searchQuery;
  String? selectedLevel;
  String? selectedOS;
  String? selectedEnvironment;
  final String projectId = '1234-abc';

  @override
  void initState() {
    super.initState();
    _logsCubit = sl<LogsCubit>();
    _logsCubit.fetchLogs('1234-abc');
    // _logsCubit.fetchLogs(sl<ProjectCubit>().state.stateData.selectedProject!.id);
  }

  void _onSearchChanged(String? value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery = value;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _logsCubit.fetchLogs(
      projectId,
      level: selectedLevel == 'All levels' ? null : selectedLevel,
      os: selectedOS == 'All OS' ? null : selectedOS,
      environment: selectedEnvironment == 'All environments'
          ? null
          : selectedEnvironment,
      search: searchQuery?.isEmpty ?? true ? null : searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchInput(
              controller: _searchController,
              hintText: 'search'.tr(),
              onChanged: _onSearchChanged,
              focusNode: _searchFocusNode,
            ),
            Row(
              children: [
                FilterElement(
                  placeholder: 'all_levels'.tr(),
                  items: const [
                    'All levels',
                    'info',
                    'debug',
                    'warning',
                    'error',
                    'critical'
                  ],
                  onChanged: (value) {
                    selectedLevel = value;
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 10),
                FilterElement(
                  placeholder: 'all_os'.tr(),
                  items: const ['All OS', 'Android', 'IOS'],
                  onChanged: (value) {
                    selectedOS = value;
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 10),
                FilterElement(
                  placeholder: 'all_environments'.tr(),
                  items: const ['All environments', 'dev', 'staging', 'prod'],
                  onChanged: (value) {
                    selectedEnvironment = value;
                    _applyFilters();
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<LogsCubit, LogsState>(
          bloc: _logsCubit,
          builder: (context, state) {
            if (state is LogsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LogsError) {
              return Center(child: Text(state.message));
            } else if (state is LogsLoaded) {
              return LogTable(logs: state.logs);
            } else {
              return const Center(child: Text('No logs found'));
            }
          },
        ),
      ],
    );
  }
}
