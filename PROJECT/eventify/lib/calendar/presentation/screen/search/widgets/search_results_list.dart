import 'package:flutter/material.dart';

class SearchResultsList extends StatelessWidget {
  final List<Widget> children;

  const SearchResultsList({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
