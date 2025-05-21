import 'package:flutter/material.dart';

class MarkdownText extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;

  const MarkdownText({
    super.key,
    required this.text,
    this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Lista para almacenar los TextSpan
    List<TextSpan> spans = [];
    // Expresión regular para encontrar **negrita**, *cursiva* y _subrayado_
    final RegExp exp = RegExp(r'\*\*(.*?)\*\*|\*(.*?)\*|_(.*?)_');
    int lastMatchEnd = 0;

    exp.allMatches(text).forEach((match) {
      // Añadir el texto antes de la coincidencia
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start), style: baseStyle));
      }

      // Procesar la coincidencia
      if (match.group(1) != null) { // Negrita (**)
        spans.add(
          TextSpan(
            text: match.group(1),
            style: (baseStyle ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
          ),
        );
      } else if (match.group(2) != null) { // Cursiva (*)
        spans.add(
          TextSpan(
            text: match.group(2),
            style: (baseStyle ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
          ),
        );
      } else if (match.group(3) != null) { // Subrayado (_)
        spans.add(
          TextSpan(
            text: match.group(3),
            style: (baseStyle ?? const TextStyle()).copyWith(decoration: TextDecoration.underline),
          ),
        );
      }
      lastMatchEnd = match.end;
    });

    // Añadir cualquier texto restante después de la última coincidencia
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: baseStyle));
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
