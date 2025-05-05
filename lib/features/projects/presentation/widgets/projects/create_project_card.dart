import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CreateProjectCard extends StatelessWidget {
  const CreateProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/create_project');
      },
      child: Container(
        width: 300,
        height: 220,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 3),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'create_project'.tr(),
                  style: AppTextStyles.headingMedium(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SvgPicture.asset(
                  'assets/icons/add_button.svg',
                  height: 15,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.surface,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
