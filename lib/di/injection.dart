import 'package:popular_movies/domain/interactors/get_favorite_movieslist_usecase.dart';
import 'package:popular_movies/domain/interactors/get_favorite_status.dart';
import 'package:popular_movies/domain/interactors/get_movie_infos.dart';
import 'package:popular_movies/domain/interactors/set_favorite_status.dart';
import 'package:popular_movies/presentation/bloc/bloc_movie_service_bloc.dart';
import 'package:popular_movies/domain/repositories/movie_repo.dart';
import 'package:popular_movies/data/service/movie_service.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/presentation/paging_bloc.dart';

import '../domain/interactors/get_movieslist_usecase.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerSingleton<MovieService>(MovieService.create()); //api chopper service

  getIt.registerFactory(() => GetMoviesListuseCase(getIt())); //use case
  getIt.registerFactory(() => GetMovieInfoUseCase(getIt())); //use case
  getIt.registerFactory(() => GetFavoritesMoviesListUseCase(getIt())); //use case
  getIt.registerFactory(() => GetFavoriteStatusUseCase(getIt()));
  getIt.registerFactory(() => SetFavoriteStatusUseCase(getIt()));

  getIt.registerFactory<MovieServiceBloc>(() => MovieServiceBloc(getIt(), getIt(), getIt(), getIt(), getIt())); //Bloc Model
  getIt.registerFactory<PagingBloc>(() => PagingBloc(getIt())); //Bloc Model

  getIt.registerSingleton<IMoviesRepository>(IMoviesRepository.getInstance()); //Repository IMoviesRepository
}
