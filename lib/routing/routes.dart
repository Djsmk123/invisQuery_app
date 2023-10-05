import 'package:go_router/go_router.dart';
import 'package:invisquery/Features/Auth/Page/View/login_screen.dart';
import 'package:invisquery/Features/Home/Page/Views/home_screen.dart';

import '../Features/SplashScreen/Page/Views/splash_screen.dart';

class AppRoutes {
  get routes => GoRouter(routes: router);

  List<GoRoute> router = [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ];
}
