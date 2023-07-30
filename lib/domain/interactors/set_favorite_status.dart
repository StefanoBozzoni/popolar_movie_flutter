import 'package:popular_movies/domain/repositories/movie_repo.dart';

import '../../data/model/movie.dart';

class SetFavoriteStatusUseCase {
  final IMoviesRepository repository;
  SetFavoriteStatusUseCase(this.repository);

  Future<bool> execute(bool isChecked, Movie movie) {
    return repository.setFavStatus(isChecked, movie);
  }
}
