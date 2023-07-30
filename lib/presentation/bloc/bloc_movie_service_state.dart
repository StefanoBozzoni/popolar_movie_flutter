part of 'bloc_movie_service_bloc.dart';

@immutable
abstract class BlocMovieServiceState {}

class BlocMovieServiceInitial extends BlocMovieServiceState {}

class BlocMovieServiceLoading extends BlocMovieServiceState {}

class BlocMovieServiceSuccess extends BlocMovieServiceState {
  final List<Movie> moviesList;
  final String listType;
  BlocMovieServiceSuccess(this.moviesList, this.listType);
}

class BlocMovieServiceDetailSuccess extends BlocMovieServiceState {
  final MovieDetailInfo movieDetailInfo;
  final bool favIsChecked;
  BlocMovieServiceDetailSuccess(this.movieDetailInfo, this.favIsChecked);
}

class BlocMovieServiceError extends BlocMovieServiceState {}
