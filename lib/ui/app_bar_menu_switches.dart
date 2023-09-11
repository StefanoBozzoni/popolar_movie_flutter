import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movies/ui/my_grid.dart';

import '../my_flutter_app_icons.dart';
import '../presentation/bloc/bloc_movie_service_bloc.dart';
import '../presentation/bloc_search_movie.dart';

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
                  flex: 3,
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
              flex: 3,
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
                flex: 3,
                fit: FlexFit.tight,
                child: Text("fav.",
                    style: TextStyle(fontSize: 11, color: (indexChecked == 2) ? Colors.black : Colors.white)),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: MySearchDelegate(), query: "");
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 8, top: 1),
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Text("search", style: TextStyle(fontSize: 11, color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ]
          .map((e) => Padding(
                padding: const EdgeInsets.only(left: 9, right: 9, top: 9),
                child: e,
              ))
          .toList(),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate() {
    query = "";
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              query = "";
              close(context, null);
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    debugPrint("XDEBUG buildresult query: $query");
    BlocProvider.of<SearchMoviesBloc>(context, listen: false).add(RequestMoviesSearch(query));
    debugPrint("XDEBUG query: $query");

    //showSuggestions;
    return BlocBuilder<SearchMoviesBloc, BlocMovieServiceState>(builder: (context, state) {
      switch (state.runtimeType) {
        case BlocMovieServiceInitial:
          {
            return const Center(child: CircularProgressIndicator());
          }
        case BlocMovieServiceLoading:
          {
            return const Center(child: CircularProgressIndicator());
          }
        case BlocMovieServiceSuccess:
          {
            final thisState = state as BlocMovieServiceSuccess;
            return MyGrid(movies: thisState.moviesList);
          }
        case BlocMovieServiceError:
          {
            return const Placeholder();
          }
        default:
          {
            return const Placeholder();
          }
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    BlocProvider.of<SearchMoviesBloc>(context, listen: false).add(RequestMoviesSearch(query));
    debugPrint("XDEBUG query: $query");

    return BlocBuilder<SearchMoviesBloc, BlocMovieServiceState>(builder: (context, state) {
      switch (state.runtimeType) {
        case BlocMovieServiceInitial:
          {
            return const Center(child: CircularProgressIndicator());
          }
        case BlocMovieServiceLoading:
          {
            return const Center(child: CircularProgressIndicator());
          }
        case BlocMovieServiceSuccess:
          {
            final thisState = state as BlocMovieServiceSuccess;


            return MyGrid(movies: thisState.moviesList);
            /*
            return ListView.builder(
              itemCount: thisState.moviesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    query = thisState.moviesList[index].title ?? "";
                    showResults(context);
                  },
                  child: ListTile(
                    title: Text(thisState.moviesList[index].title ?? ""),
                  ),
                );
              },
            );
            */
          }
        case BlocMovieServiceError:
          {
            final thisState = state as BlocMovieServiceError;
            debugPrint("XDEBUG ${thisState.toString()}");
            return const Placeholder();
          }
        default:
          {
            return const Placeholder();
          }
      }
      //return Center(child: Text(query));
    });
  }

  @override
  bool showSuggestions(BuildContext context) {
    // We don't want to show the suggestions widget
    super.showSuggestions(context);
    return true;
  }

  /*
  @override
  bool showResults(BuildContext context) {
    // We don't want to show the suggestions widget
    return true;
  }
  */
}
