import 'package:flutter/material.dart';
import 'package:flutrace_web/core/styles/font.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final bool hasError;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body(context).copyWith(
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTextStyles.body(context),
          cursorColor: Theme.of(context).colorScheme.surface,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: hasError
                  ? BorderSide(color: Theme.of(context).colorScheme.error)
                  : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: hasError
                  ? BorderSide(color: Theme.of(context).colorScheme.error)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: hasError
                  ? BorderSide(color: Theme.of(context).colorScheme.error)
                  : BorderSide(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ),
        SizedBox(
          height: 16,
          child: errorText != null
              ? Text(
            errorText!,
            style: AppTextStyles.errorHint(context),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
