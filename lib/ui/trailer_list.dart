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
        height: 200,
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
                        child: Card(
                          clipBehavior: Clip.hardEdge,
                          elevation: 4,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                    SizedBox(
                                        height: 150, width: 200,
                                        child: Stack(
                                          children: [
                                              Image.network(
                                                urlthumbnail,
                                              ),
                                              Center(
                                                  child: Transform.scale(
                                                      scale: 2, 
                                                      child: const Icon(MyFlutterApp.icPlay, color: Colors.white54))),
                                          ]
                                        ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 200,
                                        child: Padding( padding: const EdgeInsets.symmetric(horizontal: 4),
                                          child: Text(
                                            movieInfo.videos?[index].name??"",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,),
                                        )
                                        )
                                    ),
                              ],
                              ),
                        ),
                ),
              );
            }));
  }
}
