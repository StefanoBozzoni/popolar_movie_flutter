part of 'bloc_movie_service_bloc.dart';

@immutable
sealed class BlocMovieServiceEvent {}

enum EventType { popular, toprated , favorites, search}

class RequestMoviesEvent extends BlocMovieServiceEvent {
  final String requestType;
  final EventType eventType;
  RequestMoviesEvent(this.requestType, this.eventType);
}

class RequestMoviesEventPage extends RequestMoviesEvent {
  final int pageNum;
  RequestMoviesEventPage(requestType, eventType, this.pageNum) : super(requestType, eventType);
}

class RequestMoviesSearch extends BlocMovieServiceEvent {
  final String query;
  RequestMoviesSearch(this.query);
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
