import 'package:chopper/chopper.dart';
import 'header_interceptor.dart';

part 'movie_service.chopper.dart';

@ChopperApi(baseUrl: '/3')
abstract class MovieService extends ChopperService {
  @Get(path: 'movie/popular')
  Future<Response> getPopularMovies(@Query("page") int page);

  @Get(path: 'movie/top_rated')
  Future<Response> getTopRatedMovies(@Query("page") int page);

  @Get(path: 'movie/{id}/reviews')
  Future<Response> getReviews(@Path("id") int id);

  @Get(path: 'movie/{id}/videos')
  Future<Response> getVideos(@Path("id") int id);

  @Get(path: 'movie/{id}')
  Future<Response> getSingleMovie(@Path("id") int id);

  @Get(path: 'search/movie')
  Future<Response> searchMovies(@Query("query") String query);

  static MovieService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse('https://api.themoviedb.org'),
        interceptors: [HeaderInterceptor(), HttpLoggingInterceptor()],
        services: [
          _$MovieService(),
        ],
        converter: const JsonConverter());
    return _$MovieService(client);
  }
}
