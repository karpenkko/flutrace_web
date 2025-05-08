import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/core/widgets/error_display.dart';
import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';
import 'package:flutrace_web/features/analytics/presentation/widgets/analytics/layout.dart';
import 'package:flutrace_web/features/analytics/presentation/widgets/dashboard/layout.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/analytics_cubit.dart';
import 'cubit/dashboard_cubit.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  late AnalyticsCubit _analyticsCubit;
  String selectedInterval = 'day';
  String? currentProjectId;

  @override
  void initState() {
    super.initState();
    _analyticsCubit = sl<AnalyticsCubit>();
    currentProjectId = sl<ProjectCubit>().state.stateData.selectedProject?.id;
    if (currentProjectId != null) {
      _analyticsCubit.fetchAll(currentProjectId!, interval: selectedInterval);
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
              selectedInterval = 'day';
            });
            _analyticsCubit.fetchAll(selectedProject.id,
                interval: selectedInterval);
          }
        }
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
              bloc: _analyticsCubit,
              builder: (context, state) {
                if (state is AnalyticsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AnalyticsError) {
                  return Center(child: Text(state.message));
                } else if (state is AnalyticsLoaded) {
                  final data = state.stateData;
                  final isAllEmpty = data.logsCount.isEmpty &&
                      (data.summary?.osDistribution.isEmpty ?? true) &&
                      (data.summary?.topDevices.isEmpty ?? true) &&
                      (data.summary?.topMessages.isEmpty ?? true) &&
                      (data.summary?.errorsByCountry.isEmpty ?? true);

                  if (isAllEmpty) {
                    return const ErrorDisplay('no_analytics_data');
                  }

                  return AnalyticsLayout(
                    data: state.stateData.logsCount,
                    interval: state.stateData.interval,
                    summary: state.stateData.summary!,
                    onIntervalChanged: (val) {
                      _analyticsCubit.fetchLogsCount(currentProjectId!, val);
                    },
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
