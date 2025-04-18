import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String? profileImageUrl;
  final double size;
  final VoidCallback? onPressed;

  const ProfileButton({
    super.key,
    this.profileImageUrl,
    this.size = 40.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox( // Usamos SizedBox para controlar el tamaño del GestureDetector
        width: size + 10, // Aumentamos el ancho
        height: size + 10, // Aumentamos la altura
        child: Center( // Centramos el Container dentro del SizedBox
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: profileImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(profileImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: AssetImage('icons/default_profile.png'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}