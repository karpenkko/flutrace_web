import 'package:flutrace_web/core/widgets/header.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/features/projects/presentation/widgets/projects/create_project_card.dart';
import 'package:flutrace_web/features/projects/presentation/widgets/projects/project_card.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late ProjectCubit _projectsCubit;
  @override
  void initState() {
    super.initState();
    _projectsCubit = sl<ProjectCubit>();
    _projectsCubit.fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        children: [
          const AppHeader(isFull: true,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 120),
              child: BlocBuilder<ProjectCubit, ProjectState>(
                bloc: _projectsCubit,
                builder: (context, state) {
                  if (state is ProjectLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProjectLoaded) {
                    return SingleChildScrollView(
                      child: Center(
                        child: Wrap(
                          spacing: 40,
                          runSpacing: 40,
                          alignment: WrapAlignment.center,
                          children: [
                            const CreateProjectCard(),
                            ...?state.stateData.projects?.map((project) => ProjectCard(project: project)).toList(),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text('Failed to load projects'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

