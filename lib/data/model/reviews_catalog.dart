import 'package:json_annotation/json_annotation.dart';

part 'reviews_catalog.g.dart';

@JsonSerializable()
class ReviewsCatalog {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "page")
  int? page;
  @JsonKey(name: "results")
  List<Review>? results;
  @JsonKey(name: "total_pages")
  int? totalPages;
  @JsonKey(name: "total_results")
  int? totalResults;

  ReviewsCatalog({
    this.id,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory ReviewsCatalog.fromJson(Map<String, dynamic> json) => _$ReviewsCatalogFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewsCatalogToJson(this);
}

@JsonSerializable()
class Review {
  @JsonKey(name: "author")
  String? author;
  @JsonKey(name: "author_details")
  AuthorDetails? authorDetails;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;
  @JsonKey(name: "url")
  String? url;

  Review({
    this.author,
    this.authorDetails,
    this.content,
    this.createdAt,
    this.id,
    this.updatedAt,
    this.url,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable()
class AuthorDetails {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "username")
  String? username;
  @JsonKey(name: "avatar_path")
  String? avatarPath;
  @JsonKey(name: "rating")
  double? rating;

  AuthorDetails({
    this.name,
    this.username,
    this.avatarPath,
    this.rating,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) => _$AuthorDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorDetailsToJson(this);
}
