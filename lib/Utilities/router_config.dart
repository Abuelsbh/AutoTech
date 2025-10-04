import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Modules/Splash/splash_screen.dart';
import '../Modules/LanguageSelection/language_selection_screen.dart';
import '../Modules/Onboarding/onboarding_viewer_screen.dart';
import '../Modules/Permissions/notification_access_screen.dart';
import '../Modules/Permissions/location_access_screen.dart';
import '../Modules/RoleSelection/role_selection_screen.dart';
import '../Modules/Auth/login_register_screen.dart';
import '../Modules/Auth/mobile_verification_screen.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Help/help_support_screen.dart';
import '../Modules/Profile/profile_screen.dart';

BuildContext? get currentContext_ =>
    GoRouterConfig.router.routerDelegate.navigatorKey.currentContext;

class GoRouterConfig{
  static GoRouter get router => _router;
  static final GoRouter _router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: <RouteBase>[
      GoRoute(
        path: SplashScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const SplashScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: LanguageSelectionScreen.routeName,
        name: 'language-selection',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const LanguageSelectionScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: OnboardingViewerScreen.routeName,
        name: 'onboarding',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const OnboardingViewerScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: NotificationAccessScreen.routeName,
        name: 'notification-access',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const NotificationAccessScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: LocationAccessScreen.routeName,
        name: 'location-access',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const LocationAccessScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: RoleSelectionScreen.routeName,
        name: 'role-selection',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const RoleSelectionScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: LoginRegisterScreen.routeName,
        name: 'login-register',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const LoginRegisterScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: MobileVerificationScreen.routeName,
        name: 'mobile-verification',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: MobileVerificationScreen(
              phoneData: state.extra as Map<String, dynamic>?,
            ),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: HomeScreen.routeName,
        name: 'home',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const HomeScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: HelpSupportScreen.routeName,
        name: 'helpSupport',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const HelpSupportScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: ProfileScreen.routeName,
        name: 'profile',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const ProfileScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // if(!SharedPref.isLogin()) return LoginScreen.routeName;
      // if(state.matchedLocation == LoginScreen.routeName && SharedPref.isLogin()) return "/${HomeScreen.routeName}";
      return  null;
    },
  );

  static CustomTransitionPage getCustomTransitionPage({required GoRouterState state, required Widget child}){
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }
}





