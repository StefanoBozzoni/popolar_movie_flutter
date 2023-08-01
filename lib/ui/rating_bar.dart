import 'package:flutter/material.dart';

List<Widget> ratingBar(double rate) {
  int num = rate.floor();
  double diff = rate - num;
  var numList = List.generate(num, (index) => index)
      .map((e) => const Icon(
            Icons.star,
            color: Colors.red,
            size: 16,
          ))
      .toList();

  if (diff >= 0.5) {
    numList.add(const Icon(Icons.star_half, color: Colors.red, size: 16));
  }

  //final List<Icon> emptystarList = List.empty();
  var emptystarList = List.generate(10 - numList.length, (index) => index)
      .map((e) => const Icon(
            Icons.star_outline,
            color: Colors.red,
            size: 16,
          ))
      .toList();

  return numList + emptystarList;
}