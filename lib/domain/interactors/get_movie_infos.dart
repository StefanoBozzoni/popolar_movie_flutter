import 'package:popular_movies/data/model/movie_detail_info.dart';
import 'package:popular_movies/domain/repositories/movie_repo.dart';
import '../utils/result.dart';

class GetMovieInfoUseCase {
  final IMoviesRepository repository;
  GetMovieInfoUseCase(this.repository);

  Future<MyEither<MovieDetailInfo, Failure>> getMovieInfo(int id) {
    return repository.getmoviesInfo(id);
  }
}
