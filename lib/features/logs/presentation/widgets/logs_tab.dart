import 'dart:async';
import 'package:flutrace_web/core/widgets/error_display.dart';
import 'package:flutrace_web/features/logs/presentation/cubit/log_cubit.dart';
import 'package:flutrace_web/features/logs/presentation/widgets/log_detail_card.dart';
import 'package:flutrace_web/features/logs/presentation/widgets/log_table.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'filters/filter_bar.dart';


class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends State<LogsTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late LogsCubit _logsCubit;
  String? projectId;
  Timer? _debounce;

  String? searchQuery;
  String? selectedLevel;
  String? selectedOS;
  String? selectedEnvironment;

  @override
  void initState() {
    super.initState();
    _logsCubit = sl<LogsCubit>();
    projectId = sl<ProjectCubit>().state.stateData.selectedProject?.id;
    if (projectId != null) {
      _logsCubit.fetchLogs(projectId!);
      _logsCubit.startSSE(projectId!);
    }
    _scrollController.addListener(_onScroll);
  }

  void _onSearchChanged(String? value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery = value;
      _applyFilters();
    });
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final state = _logsCubit.state;
      if (state is LogsLoaded) {
        final cursor = state.stateData.cursor;
        if (cursor != null && projectId != null) {
          await _logsCubit.fetchLogs(
            projectId!,
            level: selectedLevel,
            os: selectedOS,
            environment: selectedEnvironment,
            search: searchQuery,
            cursor: cursor,
            append: true,
          );
        }
      }
    }
  }


  void _applyFilters() {
    if (projectId == null) return;
    _logsCubit.fetchLogs(
      projectId!,
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
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _logsCubit.stopSSE();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectCubit, ProjectState>(
      bloc: sl<ProjectCubit>(),
      listener: (context, state) {
        final newProject = state.stateData.selectedProject;
        if (newProject != null && newProject.id != projectId) {
          setState(() {
            projectId = newProject.id;
          });
          _logsCubit.fetchLogs(projectId!);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LogFiltersBar(
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
            onSearchChanged: _onSearchChanged,
            onLevelChanged: (value) {
              selectedLevel = value;
              _applyFilters();
            },
            onOSChanged: (value) {
              selectedOS = value;
              _applyFilters();
            },
            onEnvChanged: (value) {
              selectedEnvironment = value;
              _applyFilters();
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<LogsCubit, LogsState>(
              bloc: _logsCubit,
              builder: (context, state) {
                if (state is LogsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LogsError) {
                  return Center(child: Text(state.message));
                } else if (state is LogDetailLoaded &&
                    state.stateData.selectedLog != null) {
                  return SingleChildScrollView(
                    child: LogDetailCard(
                      log: state.stateData.selectedLog!,
                      onBack: () => _logsCubit.clearSelectedLog(),
                      isJsonView: state.stateData.isJsonView,
                      onToggleJson: () => _logsCubit.toggleJsonView(),
                    ),
                  );
                } else if (state is LogsLoaded && state.stateData.logs.isNotEmpty) {
                  return ListView(
                    controller: _scrollController,
                    children: [
                      LogTable(
                        logs: state.stateData.logs,
                        onTap: (logId) =>
                            _logsCubit.fetchLogDetail(projectId!, logId),
                      ),
                    ],
                  );
                } else {
                  return const ErrorDisplay('no_logs_found');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}





