import 'package:popular_movies/data/model/favorites.dart';
import 'package:popular_movies/domain/repositories/movie_repo.dart';

import '../utils/result.dart';

class GetFavoriteStatusUseCase {
  final IMoviesRepository repository;
  GetFavoriteStatusUseCase(this.repository);

  Future<MyEither<Favorites?, Failure>> execute(int id) {
    return repository.getFavStatus(id);
  }
}
