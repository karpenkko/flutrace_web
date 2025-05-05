import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  FutureFailable<void> signIn({required String email, required String password});
  FutureFailable<UserEntity?> getCurrentUser();
  FutureFailable<void> clearTokens();
  FutureFailable<UserEntity?> updateUser(Map<String, dynamic> fields);

}
