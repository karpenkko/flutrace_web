import 'package:flutrace_web/core/widgets/error_display.dart';
import 'package:flutrace_web/features/analytics/presentation/widgets/dashboard/layout.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/dashboard_cubit.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  late DashboardCubit _dashboardCubit;
  String? currentProjectId;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = sl<DashboardCubit>();
    currentProjectId = sl<ProjectCubit>().state.stateData.selectedProject?.id;
    if (currentProjectId != null) {
      _dashboardCubit.loadDashboard(currentProjectId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectCubit, ProjectState>(
      bloc: sl<ProjectCubit>(),
      listener: (context, state) {
        if (state is ProjectLoaded) {
          final selectedProject = state.stateData.selectedProject;
          if (selectedProject != null &&
              selectedProject.id != currentProjectId) {
            setState(() {
              currentProjectId = selectedProject.id;
            });
            _dashboardCubit.loadDashboard(selectedProject.id);
          }
        }
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: BlocBuilder<DashboardCubit, DashboardState>(
              bloc: _dashboardCubit,
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DashboardError) {
                  return Center(child: Text(state.message));
                } else if (state is DashboardLoaded) {
                  final data = state.data;

                  final isEmpty = data.totalLogsToday == 0 &&
                      data.levelDistributionToday.isEmpty &&
                      data.logCounts.isEmpty &&
                      data.topVersions.isEmpty &&
                      data.lastLogTimestamp == null;

                  if (isEmpty) {
                    return const ErrorDisplay('no_dashboard_data');
                  }

                  return DashboardLayout(
                    todaysLogs: data.totalLogsToday,
                    lastLogTime: data.lastLogTimestamp ?? DateTime.now(),
                    levelDistribution: data.levelDistributionToday,
                    logsPerDay: data.logCounts,
                    topVersions: data.topVersions,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
