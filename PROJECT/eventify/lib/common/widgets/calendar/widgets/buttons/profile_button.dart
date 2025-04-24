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
      onTap: () => _navigateToProfileScreen(context), // Llamamos a la función de navegación al tocar
      child: SizedBox(
        width: size + 10,
        height: size + 10,
        child: Center(
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