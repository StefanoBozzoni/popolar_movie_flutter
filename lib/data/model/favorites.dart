import 'package:hive/hive.dart';

part 'favorites.g.dart';

@HiveType(typeId: 1)
class Favorites {
  @HiveField(0)
  int id;
  @HiveField(1)
  String posterPath;
  Favorites({required this.id, required this.posterPath});
}
