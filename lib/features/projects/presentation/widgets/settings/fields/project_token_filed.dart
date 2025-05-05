import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectTokenField extends StatefulWidget {
  const ProjectTokenField({super.key});

  @override
  State<ProjectTokenField> createState() => _ProjectTokenFieldState();
}

class _ProjectTokenFieldState extends State<ProjectTokenField> {
  late ProjectCubit _projectCubit;
  bool _copied = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _projectCubit = sl<ProjectCubit>();
  }

  void _copyToken(String token) {
    Clipboard.setData(ClipboardData(text: token));
    setState(() => _copied = true);

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      bloc: _projectCubit,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'project_token'.tr(),
              style: AppTextStyles.body(context),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: Theme.of(context).colorScheme.surface),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.stateData.selectedProject?.id ?? '',
                      style: AppTextStyles.body(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _copied
                      ? const Icon(Icons.check, size: 20)
                      : GestureDetector(
                          onTap: () => _copyToken(
                              state.stateData.selectedProject?.id ?? ''),
                          child: const Icon(Icons.copy, size: 20),
                        ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
