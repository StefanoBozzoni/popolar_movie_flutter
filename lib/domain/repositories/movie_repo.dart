import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:popular_movies/data/model/movie.dart';
import 'package:popular_movies/data/model/movie_detail_info.dart';
import 'package:popular_movies/presentation/bloc/bloc_movie_service_bloc.dart';

import '../../data/model/favorites.dart';
import '../../data/model/movies_catalog.dart';
import '../../data/model/reviews_catalog.dart';
import '../../data/model/videos_catalog.dart';
import '../../data/service/movie_service.dart';
import '../../di/injection.dart';
import '../utils/result.dart';

abstract interface class IMoviesRepository {
  Future<MyEither<MoviesCatalog, Failure>> getMoviesList2(EventType requestType, int pageNum);
  Future<Result> getMoviesList(); //just an example of using result class
  Future<MyEither<List<Favorites>, Failure>> getFavoriteMoviesList();
  Future<MyEither<Review, Failure>> getReviews(int id);
  Future<MyEither<Video, Failure>> getVideos(int id);
  Future<MyEither<Movie, Failure>> getSingleMovie(int id);
  Future<MyEither<MovieDetailInfo, Failure>> getmoviesInfo(int id);
  Future<bool> putFavorite(Favorites aFav);
  Future<bool> deleteFavorite(int id);
  Future<MyEither<Favorites?, Failure>> getFavStatus(int id);
  Future<bool> setFavStatus(bool isChecked, Movie movie);
  static IMoviesRepository getInstance() => _MovieRepository(getIt());
}

class _MovieRepository implements IMoviesRepository {
  final MovieService movieApiService;
  _MovieRepository(this.movieApiService);

  @override
  Future<MyEither<MoviesCatalog, Failure>> getMoviesList2(EventType requestType, int pageNum) async {
    Response<dynamic> response;

    switch (requestType) {
      case EventType.popular:
        {
          response = await movieApiService.getPopularMovies(pageNum);
        }
      case EventType.toprated:
        {
          response = await movieApiService.getTopRatedMovies(pageNum);
        }

      case EventType.favorites:
        {
          throw Exception("wrong api called");
        }
    }

    if (response.isSuccessful) {
      final movies = MoviesCatalog.fromJson(response.body);
      return MyEither(success: movies);
    } else {
      return MyEither(failure: DefaultFailure(errorMessage: ""));
    }
  }

  //example using Result class as a wrapper for return value
  @override
  Future<Result> getMoviesList() async {
    Response<dynamic> response = await movieApiService.getPopularMovies(1);
    if (response.isSuccessful) {
      final movies = MoviesCatalog.fromJson(response.body);
      return ResultSuccess(movies);
    } else {
      return ResultFailure(DefaultFailure());
    }
  }

  @override
  Future<MyEither<Review, Failure>> getReviews(int id) async {
    Response<dynamic> response = await movieApiService.getReviews(id);
    if (response.isSuccessful) {
      final review = Review.fromJson(response.body);
      return MyEither(success: review);
    } else {
      return MyEither(failure: DefaultFailure(errorMessage: ""));
    }
  }

  @override
  Future<MyEither<Video, Failure>> getVideos(int id) async {
    Response<dynamic> response = await movieApiService.getReviews(id);
    if (response.isSuccessful) {
      final video = Video.fromJson(response.body);
      return MyEither(success: video);
    } else {
      return MyEither(failure: DefaultFailure(errorMessage: ""));
    }
  }

  @override
  Future<MyEither<Movie, Failure>> getSingleMovie(int id) async {
    Response<dynamic> response = await movieApiService.getSingleMovie(id);
    if (response.isSuccessful) {
      final movie = Movie.fromJson(response.body);
      return MyEither(success: movie);
    } else {
      return MyEither(failure: DefaultFailure(errorMessage: ""));
    }
  }

  @override
  Future<MyEither<MovieDetailInfo, Failure>> getmoviesInfo(int id) async {
    Future<Response<dynamic>> response1 = movieApiService.getSingleMovie(id);
    Future<Response<dynamic>> response2 = movieApiService.getReviews(id);
    Future<Response<dynamic>> response3 = movieApiService.getVideos(id);
    final movieResp = await (response1);
    final reviewResp = await (response2);
    final videoResp = await (response3);

    if (movieResp.isSuccessful && reviewResp.isSuccessful && videoResp.isSuccessful) {
      final movie = Movie.fromJson(movieResp.body);
      final review = ReviewsCatalog.fromJson(reviewResp.body);
      final video = VideosCatalog.fromJson(videoResp.body);
      return MyEither(success: MovieDetailInfo(review.results, video.results, movie));
    } else {
      return MyEither(failure: DefaultFailure(errorMessage: ""));
    }
  }

  @override
  Future<bool> putFavorite(Favorites aFav) async {
    debugPrint("put favorites");
    var box = await Hive.openBox<Favorites>('Favorites');

    await box.put(aFav.id, aFav);
    return ((box.get(aFav.id)) != null);
  }

  @override
  Future<bool> deleteFavorite(int id) async {
    debugPrint("delete favorites");
    var box = await Hive.openBox<Favorites>('Favorites');
    await box.delete(id);
    debugPrint(box.containsKey(id).toString());
    return (!box.containsKey(id));
  }

  @override
  Future<MyEither<List<Favorites>, Failure>> getFavoriteMoviesList() async {
    try {
      var box = await Hive.openBox<Favorites>('Favorites');
      return MyEither(success: box.values.toList());
    } on Exception catch (e) {
      return MyEither(failure: DefaultFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<MyEither<Favorites?, Failure>> getFavStatus(int id) async {
    try {
      var box = await Hive.openBox<Favorites>('Favorites');
      return MyEither(success: box.get(id));
    } on HttpException catch (e) {
      return MyEither(failure: DefaultFailure(errorMessage: e.message));
    }
  }

  @override
  Future<bool> setFavStatus(bool isChecked, Movie movie) async {
    if (!isChecked) {
      return await putFavorite(Favorites(id: movie.id ?? 0, posterPath: movie.posterPath ?? ""));
    } else {
      return await deleteFavorite(movie.id ?? 0);
    }
  }
}
