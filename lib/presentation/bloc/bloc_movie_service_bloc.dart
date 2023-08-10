import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movies/data/model/favorites.dart';
import 'package:popular_movies/domain/interactors/get_favorite_movieslist_usecase.dart';
import 'package:popular_movies/domain/interactors/get_favorite_status.dart';
import 'package:popular_movies/domain/interactors/get_movie_infos.dart';

import '../../data/model/movie.dart';
import '../../data/model/movie_detail_info.dart';
import '../../domain/interactors/get_movieslist_usecase.dart';
import '../../domain/interactors/set_favorite_status.dart';
import '../../domain/utils/result.dart';

part 'bloc_movie_service_event.dart';
part 'bloc_movie_service_state.dart';

class MovieServiceBloc extends Bloc<BlocMovieServiceEvent, BlocMovieServiceState> {
  MovieDetailInfo? movieInfo;
  final GetMoviesListuseCase getMoviesListUseCase;
  final GetMovieInfoUseCase getMovieInfoUseCase;
  final GetFavoritesMoviesListUseCase getFavoritesMovieInfoUseCase;
  final GetFavoriteStatusUseCase getFavoritesStatusUseCase;
  final SetFavoriteStatusUseCase setFavoritesStatusUseCase;

  Future<List<Movie>> getNewPageElements(EventType eventType, int pageNum) async {
      //execute business logic
      final moviesCatalog = await getMoviesListUseCase.getMoviesList2(eventType, pageNum);
      return moviesCatalog.success?.results??[];
  } 

  MovieServiceBloc(this.getMoviesListUseCase, this.getMovieInfoUseCase, this.getFavoritesMovieInfoUseCase,
      this.getFavoritesStatusUseCase, this.setFavoritesStatusUseCase): super(BlocMovieServiceInitial()) {
  
    on<RequestMoviesEvent>((event, emit) async {
      emit(BlocMovieServiceLoading());
      //execute business logic
      final moviesCatalog = await getMoviesListUseCase.getMoviesList2(event.eventType);

      moviesCatalog.fold(failureCond: (failure) {
        emit(BlocMovieServiceError());
      }, successCond: (data) {
        emit(BlocMovieServiceSuccess(data.results??[], event.requestType, event.eventType));
      });
    });

    on<RequestMoviesEventPage>((event, emit) async {
      emit(BlocMovieServiceLoading());
      //execute business logic
      final moviesCatalog = await getMoviesListUseCase.getMoviesList2(event.eventType, event.pageNum);

      moviesCatalog.fold(failureCond: (failure) {
        emit(BlocMovieServiceError());
      }, successCond: (data) {
        emit(BlocMovieServiceNextPage(data.results??[], event.requestType, event.pageNum, data.totalPages==event.pageNum));
      });
    });

    on<RequestMovieDetailEvent>((event, emit) async {
      emit(BlocMovieServiceLoading());
      await Future.delayed(const Duration(milliseconds: 200));

      final result = await getMovieInfoUseCase.getMovieInfo(event.id);
      final MyEither<Favorites?, Failure> favorite = await getFavoritesStatusUseCase.execute(event.id);

      if (favorite.isFailure()) {
        emit(BlocMovieServiceError());
        return;
      }

      result.fold(failureCond: (failure) {
        emit(BlocMovieServiceError());
      }, successCond: (data) {
        movieInfo = data;
        emit(BlocMovieServiceDetailSuccess(data, favorite.success != null));
      });
    });

    on<AddFavoriteMovieEvent>((event, emit) async {
      var movie = movieInfo!.movie;
      if (movieInfo == null) {
        emit(BlocMovieServiceError());
      } else {
        final result = await setFavoritesStatusUseCase.execute(event.isChecked, movie);
        if (result) {
          emit(BlocMovieServiceDetailSuccess(movieInfo!, !event.isChecked));
        } else {
          emit(BlocMovieServiceDetailSuccess(movieInfo!, event.isChecked));
        }
      }
    });

    on<RequestFavoriteMoviesEvent>((event, emit) async {
      emit(BlocMovieServiceLoading());

      //execute business logic
      final result = await getFavoritesMovieInfoUseCase.execute();

      result.fold(failureCond: (failure) {
        emit(BlocMovieServiceError());
      }, successCond: (data) {
        emit(BlocMovieServiceSuccess(data, "Grid", EventType.favorites));
      });
    });
  }
}
