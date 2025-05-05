part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String? emailError;
  final String? passwordError;
  final String? serverError;

  const AuthState({
    this.status = AuthStatus.initial,
    this.emailError,
    this.passwordError,
    this.serverError,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? emailError,
    String? passwordError,
    String? serverError,
  }) {
    return AuthState(
      status: status ?? this.status,
      emailError: emailError,
      passwordError: passwordError,
      serverError: serverError,
    );
  }
}
