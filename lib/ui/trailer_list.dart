import 'package:flutter/material.dart';
import 'package:popular_movies/data/model/movie_detail_info.dart';

import '../domain/utils/constants.dart';
import '../domain/utils/globalfunctions.dart';
import '../my_flutter_app_icons.dart';

class TrailersList extends StatelessWidget {
  final MovieDetailInfo movieInfo;
  const TrailersList({super.key, required this.movieInfo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (movieInfo.videos?.length ?? 0),
            itemBuilder: (context, index) {
              final thisMovie = movieInfo.videos?[index];
              var urlthumbnail = "$youtubeTnUrl${thisMovie?.key}/hqdefault.jpg";
              var urlVideo = "$youtubeTrailersurl${thisMovie?.key}";
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => {launchInBrowser(Uri.parse(urlVideo))},
                  child: IntrinsicWidth(
                    child: Stack(children: [
                      Image.network(
                        urlthumbnail,
                        height: 100,
                      ),
                      Center(
                          child: Transform.scale(
                              scale: 1.3, child: const Icon(MyFlutterApp.icPlay, color: Colors.white60))),
                      //CustomSingleChildLayout(delegate: )
                    ]),
                  ),
                ),
              );
            }));
  }
}
