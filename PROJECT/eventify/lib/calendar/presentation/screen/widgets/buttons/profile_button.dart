import 'package:eventify/auth/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/colors.dart'; // Import AppColors

class ProfileButton extends StatelessWidget {
  final String? profileImageUrl;
  final double size;

  const ProfileButton({
    super.key,
    this.profileImageUrl,
    this.size = 40.0,
  });

  void _navigateToProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, ProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _navigateToProfileScreen(context),
      icon: SizedBox(
        width: size,
        height: size,
        child: profileImageUrl != null
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
            : Icon(
                Icons.person,
                color: AppColors.textPrimary, // Using AppColors
              ),
      ),
      iconSize: size,
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.transparent, // Colors.transparent doesn't need to be in AppColors
        // ignore: deprecated_member_use
        highlightColor: AppColors.highlightColorGrey, // Using AppColors
      ),
      tooltip: AppStrings.profileButtonTooltip(context),
    );
  }
}
