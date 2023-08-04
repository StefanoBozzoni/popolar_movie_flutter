import 'package:popular_movies/domain/repositories/movie_repo.dart';
import 'package:popular_movies/presentation/bloc/bloc_movie_service_bloc.dart';

import '../../data/model/movies_catalog.dart';
import '../utils/result.dart';

class GetMoviesListuseCase {
  final IMoviesRepository repository;
  GetMoviesListuseCase(this.repository);

  //This response if with Result data class
  Future<Result> getMoviesList() async {
    return repository.getMoviesList();
  }

  //this response is as the previous one but it returns a MyEither class, more cool
  Future<MyEither<MoviesCatalog, Failure>> getMoviesList2(EventType requestType, [int pageNum = 1] ) {
    return repository.getMoviesList2(requestType, pageNum);
  }
}
