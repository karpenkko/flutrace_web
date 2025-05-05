import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/core/widgets/logo.dart';
import 'package:flutrace_web/features/projects/domain/entities/project_entity.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late ProjectCubit _projectsCubit;
  @override
  void initState() {
    super.initState();
    _projectsCubit = sl<ProjectCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      bloc: _projectsCubit,
      builder: (BuildContext context, ProjectState state) {
        return Container(
          width: 320,
          color: Theme.of(context).colorScheme.tertiary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Logo(),
                const SizedBox(height: 60),
                Text(
                  'projects'.tr(),
                  style: AppTextStyles.bodyLight(context),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: (state is ProjectLoaded)
                      ? ListView.builder(
                          itemCount: state.stateData.projects?.length,
                          itemBuilder: (context, index) {
                            final project = state.stateData.projects?[index];
                            return ProjectItem(project: project!, isSelected: project.id == state.stateData.selectedProject?.id);
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                GestureDetector(
                  onTap: () => context.go('/create_project'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'create_new_project'.tr(),
                          style: AppTextStyles.smallButtonTextLight(context),
                        ),
                        Icon(Icons.add, size: 22, color: Theme.of(context).colorScheme.tertiary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProjectItem extends StatelessWidget {
  final ProjectEntity project;
  final bool isSelected;


  const ProjectItem({
    required this.isSelected,
    required this.project,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
        title: Text(
          project.name,
          style: AppTextStyles.smallButtonTextDark(context),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        onTap: () {
          sl<ProjectCubit>().selectProject(project);
        },
      ),
    );
  }
}
