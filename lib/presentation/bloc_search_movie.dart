import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movies/domain/interactors/search_movies_usecase.dart';

import '../data/model/movie_detail_info.dart';
import 'bloc/bloc_movie_service_bloc.dart';

class SearchMoviesBloc extends Bloc<BlocMovieServiceEvent, BlocMovieServiceState> {
  MovieDetailInfo? movieInfo;
  final SearchMoviesUseCase searchMoviesUseCase;

  /*
  Future<List<Movie>> getNewPageElements(EventType eventType, int pageNum) async {
      //execute business logic
      final moviesCatalog = await getMoviesListUseCase.getMoviesList2(eventType, pageNum);
      return moviesCatalog.success?.results??[];
  }
  */

  SearchMoviesBloc(this.searchMoviesUseCase) : super(BlocMovieServiceInitial()) {
    on<RequestMoviesSearch>(
      (event, emit) async {
        emit(BlocMovieServiceLoading());
        final moviesCatalog = await searchMoviesUseCase.searchhMovies(event.query);
        moviesCatalog.fold(failureCond: (failure) {
          emit(BlocMovieServiceError());
        }, successCond: (data) {
          emit(BlocMovieServiceSuccess(
            data.results ?? [],
            "Grid",
            EventType.search,
          ));
        });
      },
    );
  }
}
