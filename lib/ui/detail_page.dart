import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:popular_movies/di/injection.dart';
import 'package:popular_movies/ui/reviews_list.dart';
import 'package:popular_movies/ui/trailer_list.dart';

import '../data/model/movie.dart';
import '../domain/utils/constants.dart';
import '../presentation/bloc/bloc_movie_service_bloc.dart';

class DetailPage extends StatelessWidget {
  final int id;
  static const route = '/home/detailPage/:id';
  static const route2 = '/home/detailPage2/:id';

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
          appBar: AppBar(
            title: const Text("Anteprima"),
            titleSpacing: 0,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: BlocProvider(
            create: (context) => getIt<MovieServiceBloc>(),
            child: DetailPageContent(id),
          )),
    );
  }
}

class DetailPageContent extends StatelessWidget {
  final int id;
  const DetailPageContent(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieServiceBloc, BlocMovieServiceState>(builder: (context, state) {
      switch (state.runtimeType) {
        case BlocMovieServiceInitial:
          {
            BlocProvider.of<MovieServiceBloc>(context).add(RequestMovieDetailEvent(id));
            return const CircularProgressIndicator();
          }
        case BlocMovieServiceDetailSuccess:
          {
            final movieInfo = (state as BlocMovieServiceDetailSuccess).movieDetailInfo;
            final myMovie = movieInfo.movie;

            final url = posterBaseUrl + w500 + (myMovie.backdropPath ?? "");
            final titleBackground = Theme.of(context).colorScheme.secondaryContainer;

            return ListView(
                shrinkWrap: false,
                children: addPaddingToWidgets(padding: EdgeInsets.zero, children: [
                      CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.fitWidth,
                        height: 232,
                        width: double.infinity,
                      )
                    ]) +
                    addPaddingToWidgets(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 8 , bottom: 12),
                            child: HeaderMovieInfo(
                                movie: myMovie,
                                favIsChecked: state.favIsChecked,
                                onFavClicked: (isChecked) {
                                  BlocProvider.of<MovieServiceBloc>(context).add(AddFavoriteMovieEvent(isChecked));
                                })),
                        Text(myMovie.overview ?? ""),
                        if (movieInfo.videos?.isNotEmpty ?? false)
                          Padding(
                              padding: const EdgeInsets.only(top: 24, bottom: 5),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                    color: titleBackground, borderRadius: const BorderRadius.all(Radius.circular(8))),
                                child: const Text(
                                  "Trailers",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                                ),
                              )),
                        TrailersList(movieInfo: movieInfo),
                        if (movieInfo.review?.isNotEmpty ?? false)
                          Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 5),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                    color: titleBackground, borderRadius: const BorderRadius.all(Radius.circular(8))),
                                child: const Text(
                                  "Reviews",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              )),
                        ReviewsList(movieInfo: movieInfo),
                      ],
                    ));
          }
        case BlocMovieServiceLoading:
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        default:
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      }
    });
  }
}

class HeaderMovieInfo extends StatelessWidget {
  final Movie myMovie;
  final bool favIsChecked;
  final Function(bool favoriteChecked) onFavClicked;
  const HeaderMovieInfo({super.key, required movie, required this.favIsChecked, required this.onFavClicked})
      : myMovie = movie;

  @override
  Widget build(BuildContext context) {
    final url2 = posterBaseUrl + w185 + (myMovie.posterPath ?? "");
    final String italianFormat;

    if (myMovie.releaseDate != null) {
      italianFormat = DateFormat("dd/MM/yyyy").format(myMovie.releaseDate!);
    } else {
      italianFormat = "";
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Hero(
          tag: posterImage,
          child: CachedNetworkImage(
            fadeInDuration: Duration.zero,
            imageUrl: url2,
            height: 124,
            width: 86,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                myMovie.title ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(italianFormat),
              Row(children: ratingBar(myMovie.voteAverage ?? 0)),
              Text('${(myMovie.voteAverage ?? 0).toStringAsFixed(1)}/10'),
            ],
          ),
        ),
        FavIconWidget(
          movie: myMovie,
          isChecked: favIsChecked,
          onFavClicked: onFavClicked,
        ),
      ],
    );
  }
}

class FavIconWidget extends StatefulWidget {
  final Movie movie;
  final bool isChecked;
  final Function(bool favoriteChecked) onFavClicked;
  const FavIconWidget({super.key, required this.movie, required this.isChecked, required this.onFavClicked});

  @override
  State<FavIconWidget> createState() => _FavIconWidgetState();
}

class _FavIconWidgetState extends State<FavIconWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieServiceBloc, BlocMovieServiceState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            widget.onFavClicked(widget.isChecked);
          },
          splashColor: Colors.red[100],
          customBorder: const CircleBorder(eccentricity: 0.4),
          child: Container(
            padding: const EdgeInsets.all(2),
            child: Icon(
              (widget.isChecked == false ? Icons.favorite_border : Icons.favorite),
              color: Colors.red,
              size: 25,
            ),
          ),
        );
      },
    );
  }
}

List<Widget> ratingBar(double rate) {
  int num = rate.floor();
  double diff = rate - num;
  var numList = List.generate(num, (index) => index)
      .map((e) => const Icon(
            Icons.star,
            color: Colors.red,
            size: 16,
          ))
      .toList();

  if (diff >= 0.5) {
    numList.add(const Icon(Icons.star_half, color: Colors.red, size: 16));
  }

  //final List<Icon> emptystarList = List.empty();
  var emptystarList = List.generate(10 - numList.length, (index) => index)
      .map((e) => const Icon(
            Icons.star_outline,
            color: Colors.red,
            size: 16,
          ))
      .toList();

  return numList + emptystarList;
}

class PaddingList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;

  const PaddingList(this.children, this.padding, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: children.map((child) {
        return Padding(
          padding: padding,
          child: child,
        );
      }).toList(),
    );
  }
}

List<Widget> addPaddingToWidgets(
    {EdgeInsets padding = const EdgeInsets.symmetric(vertical: 8), List<Widget> children = const []}) {
  return children.map((child) {
    return Padding(
      padding: padding,
      child: child,
    );
  }).toList();
}
