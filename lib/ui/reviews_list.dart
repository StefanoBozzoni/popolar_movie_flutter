import 'package:flutter/material.dart';
import 'package:popular_movies/domain/utils/globalfunctions.dart';

import '../data/model/movie_detail_info.dart';

class ReviewsList extends StatelessWidget {
  const ReviewsList({
    super.key,
    required this.movieInfo,
  });

  final MovieDetailInfo movieInfo;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true, //important!
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: (movieInfo.review?.length ?? 0),
        itemBuilder: (context, index) {
          final thisReview = movieInfo.review?[index];
          return Column(children: [
            InkWell(
              onTap: () => {launchInBrowser(Uri.parse(movieInfo.review?[index].url ?? ""))},
              child: Text(
                thisReview?.content ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider()
          ]);
        });
  }
}
