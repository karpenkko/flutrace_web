import 'package:flutrace_web/core/helper/type_aliases.dart';

abstract class ThemeRepository {
  FutureFailable<void> setTheme(String theme);
  FutureFailable<String?> getTheme();

  FutureFailable<void> setLanguage(String lang);
  FutureFailable<String?> getLanguage();
}
