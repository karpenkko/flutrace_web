import 'package:flutrace_web/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTheme { light, dark }

class ThemeCubit extends Cubit<AppTheme> {
  final ThemeRepository _repository;

  ThemeCubit({required ThemeRepository repository})
      : _repository = repository,
        super(AppTheme.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final response = await _repository.getTheme();
    response.fold(
      (failure) {
        emit(AppTheme.light);
      },
      (themeStr) {
        if (themeStr != null && themeStr == 'dark') {
          emit(AppTheme.dark);
        } else {
          emit(AppTheme.light);
        }
      },
    );
  }

  Future<void> toggleTheme() async {
    if (state == AppTheme.light) {
      emit(AppTheme.dark);
      await _repository.setTheme('dark');
    } else {
      emit(AppTheme.light);
      await _repository.setTheme('light');
    }
  }
}
