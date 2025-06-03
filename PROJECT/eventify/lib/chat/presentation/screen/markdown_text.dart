import 'package:flutter/material.dart';

const String markdownPattern = r'\*\*(.*?)\*\*|\*(.*?)\*|_(.*?)_';

class MarkdownText extends StatelessWidget {
  static const int boldGroup = 1;
  static const int italicGroup = 2;
  static const int underlineGroup = 3;
  static const int _startIndex = 0;

  final String text;
  final TextStyle? baseStyle;

  const MarkdownText({super.key, required this.text, this.baseStyle});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];
    final RegExp exp = RegExp(markdownPattern);
    int lastMatchEnd = _startIndex;

    exp.allMatches(text).forEach((match) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: baseStyle,
          ),
        );
      }

      // Negrita
      if (match.group(boldGroup) != null) {
        spans.add(
          TextSpan(
            text: match.group(boldGroup),
            style: (baseStyle ?? const TextStyle()).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        // Cursiva
      } else if (match.group(italicGroup) != null) {
        spans.add(
          TextSpan(
            text: match.group(italicGroup),
            style: (baseStyle ?? const TextStyle()).copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        );
        // Subrayado
      } else if (match.group(underlineGroup) != null) {
        spans.add(
          TextSpan(
            text: match.group(underlineGroup),
            style: (baseStyle ?? const TextStyle()).copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        );
      }
      lastMatchEnd = match.end;
    });

    // Añade el texto restante si lo hay
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: baseStyle));
    }

    // Devuelve el widget RichText con los estilos aplicados
    return RichText(text: TextSpan(children: spans));
  }
}
