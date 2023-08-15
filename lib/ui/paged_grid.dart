import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popular_movies/presentation/bloc_paging.dart';

import '../data/model/movie.dart';
import '../di/injection.dart';
import '../presentation/bloc/bloc_movie_service_bloc.dart';

class PagedGrid extends StatefulWidget {
  final List<Movie> movies;
  final EventType eventType;

  const PagedGrid({super.key, required this.eventType, required this.movies});

  @override
  State<PagedGrid> createState() => _PagedGridState();
}

class _PagedGridState extends State<PagedGrid> {
  final String baseImagePath = "https://image.tmdb.org/t/p/w185/";
  final PagingController<int, Movie> _pagingController = PagingController(firstPageKey: 0);
  late final bloc = getIt<PagingBloc>();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      if (pageKey >= 0) {
        bloc.add(RequestMoviesEventPage("Grid", widget.eventType, pageKey + 1));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (context) => bloc,
      child: BlocListener<PagingBloc, BlocMovieServiceState>(
          listener: (context, state) {
            if (state is BlocMovieServiceInitial) {
              debugPrint('XDEBUG initial state');
            }
            if (state is BlocMovieServiceNextPage) {
              if (state.isLastPage) {
                _pagingController.appendLastPage(state.moviesList);
              } else {
                _pagingController.appendPage(state.moviesList, state.nextPage);
              }
            }
          },
          child: BlocBuilder<PagingBloc, BlocMovieServiceState>(
              builder: (context, state) => PagedGridView<int, Movie>(
                  pagingController: _pagingController,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150, mainAxisSpacing: 8, mainAxisExtent: 190),
                  builderDelegate: PagedChildBuilderDelegate<Movie>(
                      itemBuilder: (context, item, index) => InkWell(
                            onTapDown: (details) {
                              debugPrint('XDEBUG Tap coordinate: ${details.globalPosition}');
                              final dx = details.globalPosition.dx;
                              final dy = details.globalPosition.dy;
                              context.pushNamed("detail",
                                  pathParameters: {'id': "${item.id}"}, queryParameters: {'dx': "$dx", 'dy': "$dy"});
                            },
                            /*
                            onTap: () {
                              context.pushNamed("detail", pathParameters: {'id': item.id.toString()});
                            },
                            */
                            child: CachedNetworkImage(
                                progressIndicatorBuilder: null,
                                fadeInDuration: const Duration(seconds: 0),
                                fadeOutDuration: const Duration(seconds: 0),
                                imageUrl: baseImagePath + (item.posterPath ?? ""),
                                //memCacheHeight: 300,
                                //memCacheWidth: 180,
                                placeholder: (context, url) => Container(
                                      height: 80,
                                      width: 80,
                                      color: Colors.transparent,
                                      child: const Center(
                                          widthFactor: 10, heightFactor: 10, child: CircularProgressIndicator()),
                                    )),
                          ))))));
}
