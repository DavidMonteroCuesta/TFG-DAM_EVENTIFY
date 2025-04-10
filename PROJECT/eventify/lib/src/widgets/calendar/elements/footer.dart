import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900], // Color de fondo similar al ejemplo
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.star_border, color: Colors.white),
          Icon(Icons.star_border, color: Colors.white),
          Icon(Icons.star_border, color: Colors.white),
          Icon(Icons.star_border, color: Colors.white),
        ],
      ),
    );
  }
}