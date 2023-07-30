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
        routes: [
          GoRoute(
              name: "detail2",
              path: "detailpage2/:id",
              /*
              builder: (context, state) {
                final idMovie = state.pathParameters['id'];
                return DetailPage(id: (int.parse(idMovie ?? "0")));
              },
              */
              pageBuilder: (context, state) {
                final idMovie = state.pathParameters['id'];
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: DetailPage(id: int.parse(idMovie ?? "0")),
                  transitionDuration: const Duration(milliseconds: 6000),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                      child: child,
                    );
                  },
                );
              })
        ]),
    GoRoute(
      name: "detail",
      path: DetailPage.route,
      /*
      builder: (context, state) {
        final idMovie = state.pathParameters['id'];
        return DetailPage(id: (int.parse(idMovie ?? "0"))),
        
      }
      */
      pageBuilder: (context, state) {
        final idMovie = state.pathParameters['id'];
        return CustomTransitionPage(
          key: state.pageKey,
          child: DetailPage(id: int.parse(idMovie ?? "0")),
          transitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
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
  routerNeglect: false,
);
