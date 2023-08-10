import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/movie.dart';
import '../../data/model/movie_detail_info.dart';
import '../../domain/interactors/get_movieslist_usecase.dart';
import 'bloc/bloc_movie_service_bloc.dart';

class PagingBloc extends Bloc<BlocMovieServiceEvent, BlocMovieServiceState> {
  MovieDetailInfo? movieInfo;
  final GetMoviesListuseCase getMoviesListUseCase;

  Future<List<Movie>> getNewPageElements(EventType eventType, int pageNum) async {
      //execute business logic
      final moviesCatalog = await getMoviesListUseCase.getMoviesList2(eventType, pageNum);
      return moviesCatalog.success?.results??[];
  } 

  PagingBloc(this.getMoviesListUseCase): super(BlocMovieServiceInitial()) {
    
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

  }
}
