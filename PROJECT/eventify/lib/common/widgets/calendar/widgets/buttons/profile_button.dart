import 'package:eventify/common/widgets/profile/widgets/profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String? profileImageUrl;
  final double size;

  const ProfileButton({
    super.key,
    this.profileImageUrl,
    this.size = 40.0,
  });

  void _navigateToProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToProfileScreen(context),
      child: SizedBox(
        width: size + 10,
        height: size + 10,
        child: Stack(
          alignment: Alignment.center, // Centra los elementos dentro del Stack
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: profileImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(profileImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            if (profileImageUrl == null) // Muestra el icono solo si no hay imagen de perfil
              CircleAvatar(
                backgroundColor: Colors.grey[300]?.withOpacity(0.8),
                radius: size / 2 * 0.8, // Un poco más pequeño que el fondo
                child: Icon(
                  Icons.person,
                  size: size * 0.6,
                  color: Colors.grey[700],
                ),
              ),
          ],
        ),
      ),
    );
  }
}