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
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Text(
                          style: const TextStyle(),
                          thisReview?.content ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5,)
          ]);
        });
  }
}
