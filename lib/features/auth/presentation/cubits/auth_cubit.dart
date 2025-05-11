import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/helper/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutrace_web/features/auth/domain/repositories/auth_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({
    required AuthRepository repository,
  })  : _repository = repository,
        super(const AuthState());

  Future<void> signIn(String email, String password) async {
    emit(const AuthState(status: AuthStatus.initial));

    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);

    if (emailError != null || passwordError != null) {
      emit(AuthState(
        status: AuthStatus.failure,
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(const AuthState(status: AuthStatus.loading));

    final response = await _repository.signIn(email: email, password: password);
    response.fold(
      (failure) {
        emit(AuthState(
          status: AuthStatus.failure,
          passwordError: 'incorrect_password'.tr(),
        ));
      },
      (data) {
        emit(const AuthState(status: AuthStatus.success));
      },
    );
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'email_or_password_empty'.tr();
    }
    if (!email.isValidEmail()) {
      return 'invalid_email'.tr();
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'email_or_password_empty'.tr();
    }
    if (password.length < 6) {
      return 'password_too_short'.tr();
    }
    return null;
  }

  void clearEmailError() {
    if (state.emailError != null) {
      emit(state.copyWith(emailError: null));
    }
  }

  void clearPasswordError() {
    if (state.passwordError != null) {
      emit(state.copyWith(passwordError: null));
    }
  }
}
