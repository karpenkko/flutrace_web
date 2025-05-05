import 'package:flutrace_web/features/projects/presentation/widgets/settings/delete_button.dart';
import 'package:flutter/material.dart';

import 'fields/project_name_filed.dart';
import 'fields/project_owner_fields.dart';
import 'fields/project_token_filed.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectNameField(),
                  SizedBox(height: 40),
                  ProjectTokenField(),
                  SizedBox(height: 40),
                  ProjectOwnersField(),
                ],
              ),
            ),
            DeleteButton(),
          ],
        ),
      );
  }
}

