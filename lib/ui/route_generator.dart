import 'package:flutter/material.dart';
import 'package:popular_movies/ui/first_page.dart';
import 'package:popular_movies/ui/third_page.dart';

import 'detail_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/mainPage':
        return MaterialPageRoute(builder: (context) => const FirtsPage());
      case DetailPage.route:
        {
          return MaterialPageRoute(builder: (context) => DetailPage(id: (args is int) ? args : 0));
        }
      case ThirdPage.route:
        return MaterialPageRoute(builder: (context) => const ThirdPage());
      default:
        return MaterialPageRoute(builder: (context) => const DetailPage(id: 10));
    }
  }
}
