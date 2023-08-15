import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/model/movie.dart';

class MyGrid extends StatelessWidget {
  final List<Movie> movies;
  final String baseImagePath = "https://image.tmdb.org/t/p/w185/";
  const MyGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    //timeDilation = 5.0;
    return GridView.builder(
        itemCount: movies.length,
        gridDelegate: //const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, mainAxisExtent: 190),
            const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150, mainAxisSpacing: 8, mainAxisExtent: 190),
        itemBuilder: (context, index) => InkWell(
            onTapDown: (details) {
              debugPrint('XDEBUG Tap coordinate: ${details.globalPosition}');
              final dx = details.globalPosition.dx;
              final dy = details.globalPosition.dy;
              context.pushNamed("detail",
                  pathParameters: {'id': "${movies[index].id}"}, queryParameters: {'dx': "$dx", 'dy': "$dy"});
            },
            child: CachedNetworkImage(
                imageUrl: baseImagePath + (movies[index].posterPath ?? ""),
                placeholder: (context, url) => Container(
                      height: 90,
                      width: 90,
                      color: Colors.transparent,
                      child: const Center(widthFactor: 10, heightFactor: 10, child: CircularProgressIndicator()),
                    )
                /* using the classig image.network
                child: Image.network(baseImagePath + (movies[index].posterPath ?? ""),
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (frame == null) {
                    return Container(
                      height: 90,
                      width: 90,
                      color: Colors.transparent,
                      child: const Center(widthFactor: 10, heightFactor: 10, child: CircularProgressIndicator()),
                    );
                  } else {
                    return child;
                  }
                  }
                  */
                )));
  }
}