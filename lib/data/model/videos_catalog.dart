import 'package:json_annotation/json_annotation.dart';

part 'videos_catalog.g.dart';

@JsonSerializable()
class VideosCatalog {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "results")
  List<Video>? results;

  VideosCatalog({
    this.id,
    this.results,
  });

  factory VideosCatalog.fromJson(Map<String, dynamic> json) => _$VideosCatalogFromJson(json);

  Map<String, dynamic> toJson() => _$VideosCatalogToJson(this);
}

@JsonSerializable()
class Video {
  @JsonKey(name: "iso_639_1")
  String? iso6391;
  @JsonKey(name: "iso_3166_1")
  String? iso31661;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "key")
  String? key;
  @JsonKey(name: "site")
  String? site;
  @JsonKey(name: "size")
  int? size;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "official")
  bool? official;
  @JsonKey(name: "published_at")
  DateTime? publishedAt;
  @JsonKey(name: "id")
  String? id;

  Video({
    this.iso6391,
    this.iso31661,
    this.name,
    this.key,
    this.site,
    this.size,
    this.type,
    this.official,
    this.publishedAt,
    this.id,
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
