import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invisquery/routing/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => RouteType.custom(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ); //.cupertino, .adaptive ..etc

  @override
  final List<AutoRoute> routes = <CustomRoute>[
    CustomRoute(path: '/home', page: Home.page),
    CustomRoute(
      path: '/auth',
      page: Login.page,
    ),
    CustomRoute(
      path: '/',
      initial: true,
      page: Splash.page,
    ),
  ];
}
