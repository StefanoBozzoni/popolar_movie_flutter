import 'package:flutter/material.dart';
import 'package:popular_movies/ui/detail_page.dart';
import 'package:popular_movies/ui/first_page.dart';
import 'package:popular_movies/ui/third_page.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
//final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

// GoRouter configuration
final GoRouter goRouterManager = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home/mainPage',
  routes: [
    GoRoute(
        name: 'mainPage', // Optional, add name to your routes. Allows you navigate by name instead of path
        path: FirtsPage.route,
        builder: (context, state) => const FirtsPage(),
    ),
    GoRoute(
      name: "detail",
      path: DetailPage.route,
      /* to route to a normal detail page  without transition animation
      builder: (context, state) {
        final idMovie = state.pathParameters['id'];
        return DetailPage(id: (int.parse(idMovie ?? "0"))),
      }
      */
      pageBuilder: (context, state) {
        final idMovie = state.pathParameters['id'];
        final dx = double.parse(state.queryParameters['dx'] ?? "0.0");
        final dy = double.parse(state.queryParameters['dy'] ?? "0.0");
        final mediaQuerySize = MediaQuery.sizeOf(context);
        final width = mediaQuerySize.width;
        final heigth = mediaQuerySize.height;
        return CustomTransitionPage(
          key: state.pageKey,
          child: DetailPage(id: int.parse(idMovie ?? "0")),
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 700),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
                alignment: Alignment((dx / width - 0.5) * 2, (dy / heigth - 0.5) * 2),
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: RotationTransition(
                  alignment: Alignment.topLeft,
                  turns: animation,
                  child: child,
                ));
               /* to obtain a simple fade transition: 
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                  child: child,
                );
                */
          },
        );
      },
    ),
    GoRoute(
      name: "third",
      parentNavigatorKey: _rootNavigatorKey,
      path: ThirdPage.route,
      builder: (context, state) => const ThirdPage(),
    ),
  ],
  routerNeglect: false, //to create history entry on web side
);
