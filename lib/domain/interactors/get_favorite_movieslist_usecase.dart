import 'package:popular_movies/data/model/favorites.dart';
import 'package:popular_movies/domain/repositories/movie_repo.dart';

import '../../data/model/movie.dart';
import '../utils/result.dart';

class GetFavoritesMoviesListUseCase {
  final IMoviesRepository repository;
  GetFavoritesMoviesListUseCase(this.repository);

  Future<MyEither<List<Movie>, Failure>> execute() async {
    var result = await repository.getFavoriteMoviesList();

/*
    result.fold(
        failureCond: {
          return MyEither(failure: DefaultFailure(errorMessage: (result as DefaultFailure).errorMessage));},
        successCond: {
          return MyEither(success: favlist.map((e) => Movie(id: e.id, posterPath: e.posterPath)).toList());
        }
    );
    */

    if (result is DefaultFailure) {
      return MyEither(failure: DefaultFailure(errorMessage: (result as DefaultFailure).errorMessage));
    } else {
      final favlist = (result.success as List<Favorites>);
      return MyEither(success: favlist.map((e) => Movie(id: e.id, posterPath: e.posterPath)).toList());
    }
  }
}
