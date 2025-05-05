import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/features/projects/presentation/cubit/project_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_router.dart';
import 'core/styles/theme.dart';
import 'features/auth/presentation/cubits/user_cubit.dart';
import 'features/theme/presentation/cubit/lang_cubit.dart';
import 'features/theme/presentation/cubit/theme_cubit.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await InjectionContainer().init();
  await sl<UserCubit>().loadUser();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('uk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
          BlocProvider<LanguageCubit>(create: (_) => sl<LanguageCubit>()),
          BlocProvider<UserCubit>(create: (_) => sl<UserCubit>()),
          BlocProvider<ProjectCubit>(create: (_) => sl<ProjectCubit>()),
        ],
        child: const FlutraceApp(),
      ),
    ),
  );
}

class FlutraceApp extends StatelessWidget {
  const FlutraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      themeMode: context.watch<ThemeCubit>().state == AppTheme.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      routerConfig: appRouter,
      locale: context.watch<LanguageCubit>().state,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
