import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectNameField extends StatefulWidget {
  const ProjectNameField({super.key});

  @override
  State<ProjectNameField> createState() => _ProjectNameFieldState();
}

class _ProjectNameFieldState extends State<ProjectNameField> {
  final TextEditingController _controller = TextEditingController();
  late ProjectCubit _projectCubit;
  bool _isEditing = false;
  bool _saved = false;
  Timer? _timer;
  String? _lastProjectId;

  @override
  void initState() {
    super.initState();
    _projectCubit = sl<ProjectCubit>();
    final selected = _projectCubit.state.stateData.selectedProject;
    _controller.text = selected?.name ?? '';
    _lastProjectId = selected?.id;
  }

  void _onEditTap() => setState(() => _isEditing = true);

  void _onSave() {
    final current = _projectCubit.state.stateData.selectedProject;
    if (current != null && current.name != _controller.text.trim()) {
      _projectCubit.updateProjectName(_controller.text.trim());
    }
    setState(() {
      _saved = true;
      _isEditing = false;
    });

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectCubit, ProjectState>(
      bloc: _projectCubit,
      listenWhen: (previous, current) =>
      previous.stateData.selectedProject?.id != current.stateData.selectedProject?.id,
      listener: (context, state) {
        final newProject = state.stateData.selectedProject;
        if (newProject != null) {
          _controller.text = newProject.name;
          _lastProjectId = newProject.id;
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('project_name'.tr(), style: AppTextStyles.body(context)),
          const SizedBox(height: 8),
          TextField(
            readOnly: !_isEditing,
            controller: _controller,
            style: AppTextStyles.body(context),
            cursorColor: Theme.of(context).colorScheme.surface,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _saved
                    ? const Icon(Icons.check, size: 20)
                    : IconButton(
                  icon: Icon(_isEditing ? Icons.check : Icons.edit, size: 20),
                  onPressed: _isEditing ? _onSave : _onEditTap,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
