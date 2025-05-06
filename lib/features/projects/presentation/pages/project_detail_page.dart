import 'package:flutrace_web/core/widgets/header.dart';
import 'package:flutrace_web/features/analytics/presentation/analytics_tab.dart';
import 'package:flutrace_web/features/analytics/presentation/dashboard_tab.dart';
import 'package:flutrace_web/features/logs/presentation/cubit/log_cubit.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_state_data.dart';
import 'package:flutrace_web/features/logs/presentation/widgets/logs_tab.dart';
import 'package:flutrace_web/features/projects/presentation/widgets/settings/settings_tab.dart';
import 'package:flutrace_web/features/projects/presentation/widgets/sidebar.dart';
import 'package:flutrace_web/features/projects/presentation/widgets/tab_button.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  late ProjectCubit _projectCubit;

  @override
  void initState() {
    super.initState();
    _projectCubit = sl<ProjectCubit>();
    _projectCubit.fetchProjects();
    _projectCubit.loadProjectById(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: BlocConsumer<ProjectCubit, ProjectState>(
        bloc: _projectCubit,
        listener: (context, state) {
          if (state is ProjectDeleted) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          if (state is ProjectLoaded) {
            final project = state.stateData.selectedProject;

            if (project == null) {
              return const Center(child: Text('Project not found'));
            }

            return LayoutBuilder(
                builder: (context, constraints) {
                return Row(
                  children: [
                    const Sidebar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Column(
                              children: [
                                AppHeader(
                                  isFull: false,
                                  projectName: project.name,
                                ),
                                const SizedBox(height: 20),
                                const TabsRow(),
                                const SizedBox(height: 20),
                                _buildTabContent(state.stateData.selectedTab),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            );
          } else if (state is ProjectLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('No project loaded'));
          }
        },
      ),
    );
  }

  Widget _buildTabContent(ProjectTab activeTab) {
    switch (activeTab) {
      case ProjectTab.dashboard:
        return const DashboardTab();
      case ProjectTab.logs:
        return const LogsTab();
      case ProjectTab.analytics:
        return const AnalyticsTab();
      case ProjectTab.settings:
        return const SettingsTab();
    }
  }
}
