import 'package:flutrace_web/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutrace_web/features/auth/domain/repositories/auth_repository.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository _repository;

  UserCubit({required AuthRepository repository})
      : _repository = repository,
        super(const UserInitial());

  Future<void> loadUser() async {
    print('Loading user...');
    emit(const UserLoading());
    final response = await _repository.getCurrentUser();
    response.fold(
          (failure) {
        emit(UserError(failure.errorMessage));
      },
          (data) {
        emit(UserLoaded(data!));
      },
    );
  }

  void signOut() {
    _repository.clearTokens();
    emit(const UserInitial());
  }

  Future<void> updateUser({required String email, required String password}) async {
    if (state is! UserLoaded) return;

    final currentUser = (state as UserLoaded).user;
    final Map<String, dynamic> updatedFields = {};

    if (email.trim() != currentUser.email.trim()) {
      updatedFields['email'] = email.trim();
    }

    if (password.isNotEmpty) {
      updatedFields['password'] = password;
    }

    print('Updated fields: $updatedFields');

    if (updatedFields.isEmpty) return;

    emit(const UserLoading());

    final result = await _repository.updateUser(updatedFields);

    result.fold(
          (failure) => emit(UserError(failure.errorMessage)),
          (updatedUser) => emit(UserLoaded(updatedUser!)),
    );
  }
}

