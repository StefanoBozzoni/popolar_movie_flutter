import 'package:flutter/widgets.dart';

class PaddingList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final bool nopaddingheader;

  const PaddingList({
    super.key,
    required this.children,
    required this.padding,
    this.nopaddingheader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: children.length,
            addAutomaticKeepAlives: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: (index == 0 && nopaddingheader) ? const EdgeInsets.all(0) : padding,
                child: children[index],
              );
            }));
  }
}
