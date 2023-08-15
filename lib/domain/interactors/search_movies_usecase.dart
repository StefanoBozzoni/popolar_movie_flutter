import 'package:popular_movies/domain/repositories/movie_repo.dart';

import '../../data/model/movies_catalog.dart';
import '../utils/result.dart';

class SearchMoviesUseCase {
  final IMoviesRepository repository;
  SearchMoviesUseCase(this.repository);

  //this response is as the previous one but it returns a MyEither class, more cool
  Future<MyEither<MoviesCatalog, Failure>> searchhMovies(String query) {
    return repository.searchMovies(query);
  }
}
