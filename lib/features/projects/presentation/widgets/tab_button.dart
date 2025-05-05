import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_state_data.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabsRow extends StatefulWidget {
  const TabsRow({super.key});

  @override
  State<TabsRow> createState() => _TabsRowState();
}

class _TabsRowState extends State<TabsRow> {
  late ProjectCubit _projectCubit;

  @override
  void initState() {
    super.initState();
    _projectCubit = sl<ProjectCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      bloc: _projectCubit,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TabButton(
              title: 'dashboard',
              isSelected: state.stateData.selectedTab == ProjectTab.dashboard,
              onTap: () => _projectCubit.changeTab(ProjectTab.dashboard),
            ),
            const SizedBox(width: 20),
            TabButton(
              title: 'logs',
              isSelected: state.stateData.selectedTab == ProjectTab.logs,
              onTap: () => _projectCubit.changeTab(ProjectTab.logs),
            ),
            const SizedBox(width: 20),
            TabButton(
              title: 'analytics',
              isSelected: state.stateData.selectedTab == ProjectTab.analytics,
              onTap: () => _projectCubit.changeTab(ProjectTab.analytics),
            ),
            const SizedBox(width: 20),
            TabButton(
              title: 'settings',
              isSelected: state.stateData.selectedTab == ProjectTab.settings,
              onTap: () => _projectCubit.changeTab(ProjectTab.settings),
            ),
          ],
        );
      }
    );
  }
}

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title.tr(),
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.secondary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}