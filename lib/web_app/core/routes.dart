import 'package:first_app/web_app/core/pages/help_screen.dart';
import 'package:first_app/web_app/core/pages/settings_screen.dart';
import 'package:first_app/web_app/core/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'go_router_observer.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/",
  observers: [
    GoRouterObserver(),
  ],
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/settings",
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: "/help",
      builder: (context, state) => const HelpScreen(),
    ),
  ],
);
