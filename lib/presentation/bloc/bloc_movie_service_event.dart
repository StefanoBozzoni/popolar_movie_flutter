part of 'bloc_movie_service_bloc.dart';

@immutable
sealed class BlocMovieServiceEvent {}

enum EventType { popular, toprated }

class RequestMoviesEvent extends BlocMovieServiceEvent {
  final String requestType;
  final EventType eventType;
  RequestMoviesEvent(this.requestType, this.eventType);
}

class RequestMovieDetailEvent extends BlocMovieServiceEvent {
  final int id;
  RequestMovieDetailEvent(this.id);
}

class RequestFavoriteMoviesEvent extends BlocMovieServiceEvent {
  RequestFavoriteMoviesEvent();
}

class AddFavoriteMovieEvent extends BlocMovieServiceEvent {
  final bool isChecked;
  AddFavoriteMovieEvent(this.isChecked);
}
