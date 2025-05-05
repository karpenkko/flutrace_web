import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/core/widgets/header.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _nameController = TextEditingController();
  late ProjectCubit _projectsCubit;

  @override
  void initState() {
    super.initState();
    _projectsCubit = sl<ProjectCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        children: [
          const AppHeader(isFull: true,),
          Center(
            child: BlocConsumer<ProjectCubit, ProjectState>(
              bloc: _projectsCubit,
              listener: (context, state) {
                if (state is ProjectCreated) {
                  context.go('/project/${state.stateData.selectedProject?.id}');
                }
              },
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.only(top: 100),
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'enter_project_name'.tr(),
                        style: AppTextStyles.headingExtraLarge(context),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        constraints: const BoxConstraints(minHeight: 60),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _nameController,
                            cursorColor: Theme.of(context).colorScheme.surface,
                            style: AppTextStyles.bodyMedium(context),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              hintText: 'project_name'.tr(),
                              hintStyle: AppTextStyles.bodyMedium(context).copyWith(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            await _projectsCubit.createProject(
                              _nameController.text,
                            );
                          },
                          child: Text(
                            'create'.tr(),
                            style: AppTextStyles.buttonText(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

