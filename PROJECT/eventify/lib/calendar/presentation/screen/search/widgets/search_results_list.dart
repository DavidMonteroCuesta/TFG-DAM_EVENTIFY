import 'package:flutter/material.dart';

/// Widget que muestra una lista de resultados de búsqueda de eventos
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
