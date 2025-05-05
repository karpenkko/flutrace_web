import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/features/auth/presentation/cubits/user_cubit.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectOwnersField extends StatefulWidget {
  const ProjectOwnersField({super.key});

  @override
  State<ProjectOwnersField> createState() => _ProjectOwnersFieldState();
}

class _ProjectOwnersFieldState extends State<ProjectOwnersField> {
  final TextEditingController _newOwnerController = TextEditingController();
  bool _adding = false;
  late ProjectCubit _projectCubit;
  String? _lastProjectId;

  @override
  void initState() {
    super.initState();
    _projectCubit = sl<ProjectCubit>();
    _lastProjectId = _projectCubit.state.stateData.selectedProject?.id;
  }

  void _addOwner() {
    final email = _newOwnerController.text.trim();
    if (email.isNotEmpty) {
      _projectCubit.addProjectOwner(email);
      setState(() {
        _newOwnerController.clear();
        _adding = false;
      });
    }
  }

  void _removeOwner(String email) {
    _projectCubit.removeProjectOwner(email);
  }

  @override
  void dispose() {
    _newOwnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectCubit, ProjectState>(
      bloc: _projectCubit,
      listenWhen: (prev, curr) =>
          prev.stateData.selectedProject?.id !=
          curr.stateData.selectedProject?.id,
      listener: (context, state) {
        _newOwnerController.clear();
        _adding = false;
        _lastProjectId = state.stateData.selectedProject?.id;
      },
      child: Builder(
        builder: (context) {
          final project =
              context.watch<ProjectCubit>().state.stateData.selectedProject;
          final user = context.watch<UserCubit>().state.user;

          if (project == null || user == null) return const SizedBox.shrink();

          final allUsers = project.users;
          final currentUserEmail = user.email;
          final sortedUsers = [
            currentUserEmail,
            ...allUsers.where((email) => email != currentUserEmail),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('project_owners'.tr(), style: AppTextStyles.body(context)),
              const SizedBox(height: 8),
              ...sortedUsers.map((email) {
                final isCurrentUser = email == user.email;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(email,
                                style: AppTextStyles.body(context))),
                        if (!isCurrentUser)
                          GestureDetector(
                            onTap: () => _removeOwner(email),
                            child: const Icon(Icons.close, size: 20),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              if (_adding)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _newOwnerController,
                    autofocus: true,
                    style: AppTextStyles.body(context),
                    decoration: InputDecoration(
                      hintText: 'email'.tr(),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 18),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: _addOwner,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => setState(() => _adding = true),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'add_member'.tr(),
                          style: AppTextStyles.smallButtonTextDark(context),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.add,
                          size: 20,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
