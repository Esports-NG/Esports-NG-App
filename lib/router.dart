import 'package:e_sport/ui/auth/splash_screen.dart';
import 'package:e_sport/ui/events/events.dart';
import 'package:e_sport/ui/home/home.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

GoRouter goRouter() {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: Get.key,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder:(context, state) {
          return const SplashScreen();
        },
        ),
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) {
          return const EventsPage(); 
        },
        )
    ]
  );
}