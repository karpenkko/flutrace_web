import 'package:flutrace_web/core/error/failures.dart';
import 'package:flutrace_web/core/error/repository_request_handler.dart';
import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/auth/data/datasource/auth_datasource.dart';
import 'package:flutrace_web/features/auth/domain/entities/user_entity.dart';
import 'package:flutrace_web/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required this.datasource,
  });

  final AuthDatasource datasource;

  @override
  FutureFailable<void> signIn({
    required String email,
    required String password,
  }) {
    return RepositoryRequestHandler<void>()(
      request: () async {
        await datasource.signIn(email: email, password: password);
      },
      defaultFailure: IncorrectPasswordFailure(),
    );
  }

  @override
  FutureFailable<UserEntity?> getCurrentUser() {
    return RepositoryRequestHandler<UserEntity?>()(
      request: () async {
        final result = await datasource.getCurrentUser();
        return result;
      },
      defaultFailure: IncorrectPasswordFailure(),
    );
  }

  @override
  FutureFailable<void> clearTokens() {
    return RepositoryRequestHandler<void>()(
      request: () async {
        await datasource.clearTokens();
      },
      defaultFailure: IncorrectPasswordFailure(),
    );
  }

  @override
  FutureFailable<UserEntity?> updateUser(Map<String, dynamic> fields) {
    return RepositoryRequestHandler<UserEntity?>()(
      request: () async {
        final result = await datasource.updateUser(fields);
        return result;
      },
      defaultFailure: IncorrectPasswordFailure(),
    );
  }
}
