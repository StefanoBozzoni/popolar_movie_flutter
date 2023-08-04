// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$MovieService extends MovieService {
  _$MovieService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = MovieService;

  @override
  Future<Response<dynamic>> getPopularMovies(int page) {
    final Uri $url = Uri.parse('/3/movie/popular');
    final Map<String, dynamic> $params = <String, dynamic>{'page': page};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTopRatedMovies(int page) {
    final Uri $url = Uri.parse('/3/movie/top_rated');
    final Map<String, dynamic> $params = <String, dynamic>{'page': page};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getReviews(int id) {
    final Uri $url = Uri.parse('/3/movie/${id}/reviews');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getVideos(int id) {
    final Uri $url = Uri.parse('/3/movie/${id}/videos');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getSingleMovie(int id) {
    final Uri $url = Uri.parse('/3/movie/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
