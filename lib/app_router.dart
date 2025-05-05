import 'package:go_router/go_router.dart';
import 'package:flutrace_web/features/auth/presentation/pages/sign_in_page.dart';

import 'core/services/local_preferences.dart';
import 'features/projects/presentation/pages/create_project_screen.dart';
import 'features/projects/presentation/pages/project_detail_page.dart';
import 'features/projects/presentation/pages/projects_page.dart';
import 'injection_container.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: sl<LocalStorageService>().getString('access_token') != null ? '/home' : '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SignInPage(),
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: ProjectsPage(),
      ),
    ),
    GoRoute(
      path: '/create_project',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: CreateProjectPage(),
      ),
      builder: (context, state) => const CreateProjectPage(),
    ),
    GoRoute(
      path: '/project/:id',
      pageBuilder: (context, state) {
        final projectId = state.pathParameters['id']!;
        return NoTransitionPage(
          child: ProjectDetailsPage(projectId: projectId),
        );
      },
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = sl<LocalStorageService>().getString('access_token') != null;
    final isLoggingIn = state.uri.path == '/';

    if (!isLoggedIn && !isLoggingIn) {
      return '/';
    }

    if (isLoggedIn && isLoggingIn) {
      return '/home';
    }

    return null;
  },
);

