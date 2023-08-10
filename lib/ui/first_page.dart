import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_movies/my_flutter_app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popular_movies/ui/paged_grid.dart';
import '../data/model/movie.dart';
import '../di/injection.dart';
import '../domain/utils/constants.dart';
import '../presentation/bloc/bloc_movie_service_bloc.dart';

class FirtsPage extends StatelessWidget {
  static const route = "/home/mainpage";
  static const route2 = "/home/mainpage2";

  const FirtsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => getIt<MovieServiceBloc>(),
        child: BlocBuilder<MovieServiceBloc, BlocMovieServiceState>(
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    title: const Text("Popular movies"),
                    automaticallyImplyLeading: false,
                    actions: [
                      AppbarMenuSwitches(
                        onPressed: (index) {
                          switch (index) {
                            case 0:
                              BlocProvider.of<MovieServiceBloc>(context)
                                  .add(RequestMoviesEvent("PagedGrid", EventType.popular));
                            case 1:
                              BlocProvider.of<MovieServiceBloc>(context)
                                  .add(RequestMoviesEvent("PagedGrid", EventType.toprated));
                            case 2:
                              BlocProvider.of<MovieServiceBloc>(context).add(RequestFavoriteMoviesEvent());
                          }
                        },
                      )
                    ]),
                body: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: NetworkImage(mainpagebackGroundUrl), fit: BoxFit.fill),
                  ),
                  child: BodyFirstPage(state: state),
                ));
          },
        ),
      );
}

class AppbarMenuSwitches extends StatefulWidget {
  final Function(int index) onPressed;
  const AppbarMenuSwitches({super.key, required this.onPressed});

  @override
  State<AppbarMenuSwitches> createState() => _AppbarMenuSwitchesState();
}

class _AppbarMenuSwitchesState extends State<AppbarMenuSwitches> {
  late int indexChecked;

  @override
  void initState() {
    super.initState();
    indexChecked = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key(indexChecked.toString()),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              indexChecked = 0;
            });
            widget.onPressed(indexChecked);
          },
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: Icon(MyFlutterApp.icPopular, color: (indexChecked == 0) ? Colors.black : Colors.white, size: 26),
              ),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    "popular",
                    style: TextStyle(fontSize: 11, color: (indexChecked == 0) ? Colors.black : Colors.white),
                  ))
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              indexChecked = 1;
            });
            widget.onPressed(indexChecked);
          },
          child: Column(children: [
            Flexible(
              flex: 3,
              child: Icon(
                MyFlutterApp.icTopRated,
                color: (indexChecked == 1) ? Colors.black : Colors.white,
                size: 25,
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child:
                  Text("top", style: TextStyle(fontSize: 11, color: (indexChecked == 1) ? Colors.black : Colors.white)),
            )
          ]),
        ),
        InkWell(
          onTap: () {
            setState(() {
              indexChecked = 2;
            });
            widget.onPressed(indexChecked);
          },
          child: Container(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: Icon(
                    MyFlutterApp.icFavoriteBorderWhite24dp,
                    color: (indexChecked == 2) ? Colors.black : Colors.white,
                    size: 25,
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text("fav.",
                      style: TextStyle(fontSize: 11, color: (indexChecked == 2) ? Colors.black : Colors.white)),
                )
              ],
            ),
          ),
        ),
      ]
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: e,
              ))
          .toList(),
    );
  }
}

class BodyFirstPage extends StatelessWidget {
  final BlocMovieServiceState state;
  const BodyFirstPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.runtimeType) {
      case BlocMovieServiceInitial:
        {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    BlocProvider.of<MovieServiceBloc>(context).add(RequestMoviesEvent("List", EventType.popular));
                  },
                  child: const Text("Movies List")),
              IconButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    backgroundColor: Colors.blue,
                    alignment: Alignment.center),
                icon: const Icon(
                  MyFlutterApp.group1,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<MovieServiceBloc>(context).add(RequestMoviesEvent("Grid", EventType.popular));
                  },
                  child: const Text("Movies Grid")),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<MovieServiceBloc>(context).add(RequestMoviesEvent("PagedGrid", EventType.popular));
                  },
                  child: const Text("Movies paged Grid")),
            ],
          );
        }

      case BlocMovieServiceLoading:
        {
          return const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }

      case BlocMovieServiceSuccess:
        {
          var thisState = state as BlocMovieServiceSuccess;
          return switch (thisState.listType) {
            "List" => MyList(movies: thisState.moviesList),
            "Grid" => MyGrid(movies: thisState.moviesList),
            "PagedGrid" => PagedGrid(eventType: thisState.eventType, movies: thisState.moviesList),
            _ => const Placeholder()
          };
        }

      case BlocMovieServiceError:
        {
          return const Center(child: Text("an error accourred"));
        }

      default:
        {
          return const Placeholder();
        }
    }
  }
}

//movies grid, not paginated
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
                  pathParameters: {'id': "${movies[index].id}"},
                  queryParameters: {'dx': "$dx", 'dy': "$dy"});
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

//Movies, not paginated
class MyList extends StatelessWidget {
  final List<Movie> movies;
  final String baseImagePath = "https://image.tmdb.org/t/p/w185/";
  const MyList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) => InkWell(
            onTap: () {
              context.pushNamed("detail", pathParameters: {'id1': movies[index].id.toString()});
            },
            child: Image.network(
              baseImagePath + (movies[index].posterPath ?? ""),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (frame == null) {
                  return Container(
                    height: 195,
                    width: double.infinity,
                    color: Colors.transparent,
                    child: const Center(widthFactor: 10, heightFactor: 10, child: CircularProgressIndicator()),
                  );
                } else {
                  return Column(
                    children: [
                      Text(
                        movies[index].title ?? "",
                        style: const TextStyle(backgroundColor: Colors.transparent),
                      ),
                      child,
                    ],
                  );
                }
              },
            )));
  }
}
