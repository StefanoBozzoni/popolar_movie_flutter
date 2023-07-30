import 'movie.dart';
import 'reviews_catalog.dart';
import 'videos_catalog.dart';

class MovieDetailInfo {
  List<Review>? review;
  List<Video>? videos;
  Movie movie;
  MovieDetailInfo(this.review, this.videos, this.movie);
}
