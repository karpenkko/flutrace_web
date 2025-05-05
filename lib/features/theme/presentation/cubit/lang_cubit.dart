import 'package:flutrace_web/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageCubit extends Cubit<Locale> {
  final ThemeRepository _repository;

  LanguageCubit({required ThemeRepository repository})
      : _repository = repository,
        super(const Locale('en')) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final response = await _repository.getLanguage();
    response.fold(
      (failure) {
        emit(const Locale('en'));
      },
      (langCode) {
        if (langCode != null && langCode.isNotEmpty) {
          emit(Locale(langCode));
        } else {
          emit(const Locale('en'));
        }
      },
    );
  }

  Future<void> changeLanguage(BuildContext context, Locale newLocale) async {
    await context.setLocale(newLocale);
    await _repository.setLanguage(newLocale.languageCode);
    emit(newLocale);
  }

  Future<void> toggleLanguage(BuildContext context) async {
    if (state.languageCode == 'en') {
      await changeLanguage(context, const Locale('uk'));
    } else {
      await changeLanguage(context, const Locale('en'));
    }
  }
}
