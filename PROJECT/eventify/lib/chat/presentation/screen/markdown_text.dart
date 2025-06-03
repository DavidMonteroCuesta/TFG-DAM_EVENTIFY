import 'package:flutter/material.dart';

const String markdownPattern = r'\*\*(.*?)\*\*|\*(.*?)\*|_(.*?)_';

class MarkdownText extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;

  const MarkdownText({super.key, required this.text, this.baseStyle});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];
    final RegExp exp = RegExp(markdownPattern);
    int lastMatchEnd = 0;

    exp.allMatches(text).forEach((match) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: baseStyle,
          ),
        );
      }

      if (match.group(1) != null) {
        spans.add(
          TextSpan(
            text: match.group(1),
            style: (baseStyle ?? const TextStyle()).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (match.group(2) != null) {
        spans.add(
          TextSpan(
            text: match.group(2),
            style: (baseStyle ?? const TextStyle()).copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      } else if (match.group(3) != null) {
        spans.add(
          TextSpan(
            text: match.group(3),
            style: (baseStyle ?? const TextStyle()).copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        );
      }
      lastMatchEnd = match.end;
    });

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: baseStyle));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
