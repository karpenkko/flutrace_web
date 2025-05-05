import 'package:flutrace_web/core/services/local_preferences.dart';

const String themeKey = 'app_theme';
const String languageKey = 'app_language';

abstract class ThemeLocalDatasource {
  Future<void> setTheme(String theme);
  Future<String?> getTheme();
  Future<void> setLanguage(String lang);
  Future<String?> getLanguage();
}

class ThemeLocalDatasourceImpl extends ThemeLocalDatasource {
  ThemeLocalDatasourceImpl({required this.localStorage});

  final LocalStorageService localStorage;

  @override
  Future<void> setTheme(String theme) async {
    await localStorage.setString(themeKey, theme);
  }

  @override
  Future<String?> getTheme() async {
    return localStorage.getString(themeKey);
  }

  @override
  Future<void> setLanguage(String lang) async {
    await localStorage.setString(languageKey, lang);
  }

  @override
  Future<String?> getLanguage() async {
    return localStorage.getString(languageKey);
  }
}