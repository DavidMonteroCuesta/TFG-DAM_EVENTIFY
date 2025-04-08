import 'package:flutter/material.dart';

class BottomNavigationBarButtons extends StatelessWidget {
  const BottomNavigationBarButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: const BoxDecoration(
        color: Color(0xFF2B2B2B),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20), // Espacio antes de los botones
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, // Usando el color primario del tema
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          const SizedBox(width: 30), // Espacio entre botones
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, // Usando el color primario del tema
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          const SizedBox(width: 30), // Espacio entre botones
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, // Usando el color primario del tema
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          const SizedBox(width: 30), // Espacio entre botones
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, // Usando el color primario del tema
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          const SizedBox(width: 20), // Espacio después de los botones
        ],
      ),
    );
  }
}
