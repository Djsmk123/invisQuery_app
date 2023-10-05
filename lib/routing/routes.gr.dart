// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:invisquery/Features/Auth/Page/View/login_screen.dart' as _i2;
import 'package:invisquery/Features/Home/Page/Views/home_screen.dart' as _i1;
import 'package:invisquery/Features/SplashScreen/Page/Views/splash_screen.dart'
    as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    Home.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    Login.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    Splash.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeScreen]
class Home extends _i4.PageRouteInfo<void> {
  const Home({List<_i4.PageRouteInfo>? children})
      : super(
          Home.name,
          initialChildren: children,
        );

  static const String name = 'Home';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoginScreen]
class Login extends _i4.PageRouteInfo<void> {
  const Login({List<_i4.PageRouteInfo>? children})
      : super(
          Login.name,
          initialChildren: children,
        );

  static const String name = 'Login';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SplashScreen]
class Splash extends _i4.PageRouteInfo<void> {
  const Splash({List<_i4.PageRouteInfo>? children})
      : super(
          Splash.name,
          initialChildren: children,
        );

  static const String name = 'Splash';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}
