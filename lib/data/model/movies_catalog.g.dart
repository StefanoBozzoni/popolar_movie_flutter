// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoviesCatalog _$MoviesCatalogFromJson(Map<String, dynamic> json) =>
    MoviesCatalog(
      page: json['page'] as int?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['totalPages'] as int?,
      totalResults: json['totalResults'] as int?,
    );

Map<String, dynamic> _$MoviesCatalogToJson(MoviesCatalog instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'totalPages': instance.totalPages,
      'totalResults': instance.totalResults,
    };
