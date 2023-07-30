import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  static const route = '/home/thirdPage';
  static const route2 = '/home/thirdPage2';
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Material(
            child: Center(
                child: Text(
          "Third page",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ))));
  }
}
