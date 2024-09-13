import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../screens/dashboard_screen.dart';
import '../screens/quiz_screen.dart';
import '../services/analytics_service.dart';

typedef GetOffsetMethod = double Function();
typedef SetOffsetMethod = void Function(double offset);
double listViewOffset = 0.0;

class RouterAppConfig {
  static final RouterAppConfig _instance = RouterAppConfig._();
  RouterAppConfig._();
  factory RouterAppConfig() {
    return _instance;
  }

  GoRouter? _router;
  GoRouter? get router => _router;

  void initialize() {
    if (_router != null) return;
    final analyticsService = Get.find<AnalyticsService>();

    _router = GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: Get.key,
      initialLocation: '/',
      observers: [analyticsService.getAnalyticsObserver()], // Add this line
      errorPageBuilder: (context, state) {
        return NoTransitionPage(key: state.pageKey, child: DashboardScreen());
      },
      routes: <RouteBase>[
        GoRoute(
            path: '/',
            parentNavigatorKey: Get.key,
            builder: (BuildContext context, GoRouterState state) {
              return DashboardScreen();
            }),
        GoRoute(
          path: '/quiz/:roomId',
          builder: (context, state) => QuizScreen(
            roomId: state.pathParameters['roomId']!,
            userName: state.extra as String,
          ),
        ),
      ],
    );
  }
}
