import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutrace_web/features/auth/presentation/cubits/user_cubit.dart';
import 'package:flutrace_web/core/styles/font.dart';

class UserProfilePopup extends StatefulWidget {
  const UserProfilePopup({super.key});

  @override
  State<UserProfilePopup> createState() => _UserProfilePopupState();
}

class _UserProfilePopupState extends State<UserProfilePopup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hasChanges = false;
  bool _obscurePassword = true;
  bool _passwordEdited = false;
  late FocusNode _passwordFocusNode;

  late UserCubit _userCubit;

  @override
  void initState() {
    super.initState();
    _userCubit = sl<UserCubit>();
    _userCubit.loadUser();

    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(_handlePasswordFocusChange);
  }

  void _handlePasswordFocusChange() {
    if (!_passwordFocusNode.hasFocus && _passwordEdited && _passwordController.text.isEmpty) {
      setState(() {
        _passwordEdited = false;
        _obscurePassword = true;
        _passwordController.text = '••••••••';
      });
    }
  }

  void _onFieldChanged() => setState(() => _hasChanges = true);

  void _onPasswordChanged(String value) {
    if (!_passwordEdited) {
      setState(() {
        _passwordController.clear();
        _passwordEdited = true;
      });
    }
    _onFieldChanged();
  }

  void _onSave() {
    final password = _passwordEdited && _passwordController.text.isNotEmpty
        ? _passwordController.text
        : '';

    context.read<UserCubit>().updateUser(
      email: _emailController.text,
      password: password,
    );

    setState(() => _hasChanges = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }


  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body(context),
        ),
        const SizedBox(height: 8),
        TextField(
          focusNode: focusNode,
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          onTap: onTap,
          onChanged: onChanged,
          style: AppTextStyles.body(context),
          cursorColor: Theme.of(context).colorScheme.surface,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).primaryColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            suffixIcon: suffixIcon,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<UserCubit, UserState>(
      bloc: _userCubit,
      listener: (context, state) {
        if (state is UserLoaded) {
          _emailController.text = state.user.email;
          _passwordController.text = '••••••••';
        }
      },
      child: Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(top: 12, right: 60),
            padding: const EdgeInsets.all(16),
            width: 400,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildField(
                  label: 'email'.tr(),
                  controller: _emailController,
                  onChanged: (_) => _onFieldChanged(),
                  suffixIcon: const Icon(Icons.edit, size: 20),
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: 'password'.tr(),
                  controller: _passwordController,
                  isPassword: true,
                  onTap: () {
                    if (!_passwordEdited) {
                      _passwordController.clear();
                      setState(() => _passwordEdited = true);
                    }
                  },
                  onChanged: _onPasswordChanged,
                  focusNode: _passwordFocusNode,
                  suffixIcon: _passwordEdited
                      ? IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  )
                      : const Icon(Icons.edit, size: 20),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasChanges
                          ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _hasChanges ? _onSave : null,
                    child: Text(
                      'save'.tr(),
                      style: AppTextStyles.smallButtonTextDark(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
