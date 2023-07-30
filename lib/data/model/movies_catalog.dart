import 'package:popular_movies/data/model/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movies_catalog.g.dart';

@JsonSerializable()
class MoviesCatalog {
  int? page;
  List<Movie>? results;
  int? totalPages;
  int? totalResults;

  MoviesCatalog({this.page, this.results, this.totalPages, this.totalResults});

  factory MoviesCatalog.fromJson(Map<String, dynamic> json) => _$MoviesCatalogFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesCatalogToJson(this);
}
