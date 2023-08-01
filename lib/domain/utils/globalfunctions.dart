import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

List<Widget> addPaddingToWidgets(
    {EdgeInsets padding = const EdgeInsets.symmetric(vertical: 8), List<Widget> children = const []}) {
  return children.map((child) {
    return Padding(
      padding: padding,
      child: child,
    );
  }).toList();
}
