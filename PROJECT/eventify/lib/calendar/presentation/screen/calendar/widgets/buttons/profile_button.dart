import 'package:eventify/auth/presentation/screen/profile/profile_screen.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

// Widget que muestra el botón de perfil, permitiendo acceder a la pantalla de perfil del usuario.
class ProfileButton extends StatelessWidget {
  static const double _defaultSize = 40.0;

  final String? profileImageUrl;
  final double size;

  const ProfileButton({
    super.key,
    this.profileImageUrl,
    this.size = _defaultSize,
  });

  void _navigateToProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, ProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Botón de perfil que muestra la imagen del usuario o un icono por defecto.
    return IconButton(
      onPressed: () => _navigateToProfileScreen(context),
      icon: SizedBox(
        width: size,
        height: size,
        child:
            profileImageUrl != null
                ? Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(profileImageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                : Icon(Icons.person, color: AppColors.textPrimary),
      ),
      iconSize: size,
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.transparent,
        highlightColor: AppColors.highlightColorGrey,
      ),
      tooltip: AppStrings.profileButtonTooltip(context),
    );
  }
}
