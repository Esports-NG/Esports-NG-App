import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/screens/account/user_details.dart';
import 'package:e_sport/ui/screens/auth/splash_screen.dart';
import 'package:e_sport/ui/screens/nav/events.dart';
import 'package:e_sport/ui/screens/nav/home.dart';
import 'package:e_sport/ui/screens/nav/root.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

GoRouter goRouter() {
  final authController = Get.put(AuthRepository());
  return GoRouter(
      initialLocation: '/',
      navigatorKey: Get.key,
      routes: <RouteBase>[
        GoRoute(
            path: '/',
            builder: (context, state) {
              return const SplashScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (_, __) {
                    return const RootDashboard();
                  }),
            ]),
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (_, __) {
            return const EventsPage();
          },
        ),
        GoRoute(
          path: '/my-account',
          name: 'my-account',
          builder: (_, __) {
            final slug = authController.user!.slug!;
            return UserDetails(slug: slug);
          },
        ),
      ]);
}
