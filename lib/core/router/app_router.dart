import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_providers.dart';
import '../../features/auth/email_auth_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/phone_auth_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/language/language_selection_screen.dart';
import '../../features/result/result_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/units/units_input_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  final onboardingComplete = ref.watch(onboardingCompleteProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final path = state.uri.path;
      final isSplash = path == '/splash';
      final isLogin = path.startsWith('/login');
      final isLanguage = path == '/language';

      if (isSplash) return null;

      if (!auth.isAuthenticated) {
        return isLogin ? null : '/login';
      }

      if (!onboardingComplete && !isLanguage) {
        return '/language';
      }

      if (isLogin || isLanguage) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'phone',
            builder: (context, state) => const PhoneAuthScreen(),
          ),
          GoRoute(
            path: 'email',
            builder: (context, state) => const EmailAuthScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/units',
        builder: (context, state) => const UnitsInputScreen(),
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
