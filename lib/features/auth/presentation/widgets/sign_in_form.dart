import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/core/widgets/logo.dart';
import 'package:flutrace_web/core/widgets/text_field.dart';
import 'package:flutrace_web/features/auth/presentation/cubits/user_cubit.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutrace_web/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:go_router/go_router.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();

    _emailController.addListener(() {
      _authCubit.clearEmailError();
    });

    _passwordController.addListener(() {
      _authCubit.clearPasswordError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state.status == AuthStatus.success) {
              await sl<UserCubit>().loadUser();
              context.go('/home');
            }
          },
        builder: (context, state) {
          return Stack(
            children: [
              const Positioned(
                top: 0,
                left: 0,
                child: Logo(),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'sign_in'.tr(),
                      style: AppTextStyles.headingLarge(context),
                    ),
                    const SizedBox(height: 64),
                    AppTextField(
                      controller: _emailController,
                      label: 'email'.tr(),
                      keyboardType: TextInputType.emailAddress,
                      hasError: state.emailError != null,
                      errorText: state.emailError,
                    ),
                    const SizedBox(height: 6),
                    AppTextField(
                      controller: _passwordController,
                      label: 'password'.tr(),
                      obscureText: true,
                      hasError: state.passwordError != null,
                      errorText: state.passwordError,
                    ),
                    const SizedBox(height: 36),
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
                        onPressed: () {
                          _authCubit.signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                        },
                        child: Text(
                          'start'.tr(),
                          style: AppTextStyles.buttonText(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
