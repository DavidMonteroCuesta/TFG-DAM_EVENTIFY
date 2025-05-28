import 'dart:ui'; // <-- Añadido para BackdropFilter
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/utils/auth/logout_service.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/utils/dates/date_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/colors/app_colors_palette.dart'; // Asegúrate de importar AppColorPalette

class ProfileScreen extends StatefulWidget {
  static String routeName = 'profile';
  static String routePath = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditProfileExpanded = false;
  bool _isNotificationSettingsExpanded = false;
  bool _isTermsOfServiceExpanded = false;
  bool _isSupportExpanded = false;
  bool _isThemeColorExpanded = false;

  final List<Color?> _availableColors = [
    null, // Representa "Predeterminado"
    AppColorPalette.greenAccent,
    AppColorPalette.blueAccent,
    AppColorPalette.orangeAccent,
    AppColorPalette.redAccent,
  ];

  final List<String> _colorNames = [
    'Predeterminado',
    'Verde',
    'Azul',
    'Naranja',
    'Rojo',
  ];

  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    Color? currentAppThemeColor = AppColors.secondaryDynamic; // Color actual del tema global

    // Buscar si el color del tema actual coincide con alguna de nuestras opciones del dropdown
    Color? matchedDropdownValue;
    for (int i = 0; i < _availableColors.length; i++) {
      Color? optionColor = _availableColors[i];
      if (optionColor == null) { // Caso "Predeterminado"
        if (currentAppThemeColor == AppColorPalette.greenAccent) {
          matchedDropdownValue = null;
          break;
        }
      } else {
        if (optionColor == currentAppThemeColor) {
          matchedDropdownValue = optionColor;
          break;
        }
      }
    }

    _selectedColor = matchedDropdownValue;
    if (currentAppThemeColor == AppColorPalette.greenAccent && _selectedColor != null) {
      _selectedColor = null;
    }
  }

  String get _firstLetter {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? AppInternalConstants.profileUsernameDefault;
    return username.isNotEmpty ? username[0].toUpperCase() : '';
  }

  void _navigateToCalendarScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarScreen()),
    );
  }

  void _toggleEditProfile() {
    setState(() {
      _isEditProfileExpanded = !_isEditProfileExpanded;
    });
  }

  void _toggleNotificationSettings() {
    setState(() {
      _isNotificationSettingsExpanded = !_isNotificationSettingsExpanded;
    });
  }

  void _toggleTermsOfService() {
    setState(() {
      _isTermsOfServiceExpanded = !_isTermsOfServiceExpanded;
    });
  }

  void _toggleSupport() {
    setState(() {
      _isSupportExpanded = !_isSupportExpanded;
    });
  }

  void _toggleThemeColor() {
    setState(() {
      _isThemeColorExpanded = !_isThemeColorExpanded;
    });
  }

  void _changeThemeColor(Color? newColor) async {
    AppColors.currentUserSelectedColor = newColor;
    await AppColors.saveThemeColor(newColor);
    if (mounted) {
      setState(() {
        _selectedColor = newColor;
      });
      (context as Element).markNeedsBuild();
    }
  }

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.profileContactUsText(context)),
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.snackBarInfoColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = AppColors.errorTextColor;
    final currentDate = DateFormatter.getCurrentDateFormatted();

    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? AppInternalConstants.profileUsernameDefault;
    final email = user?.email ?? AppInternalConstants.profileEmailDefault;

    const double headerHeight = 120.0;
    const double avatarRadius = 40.0;
    const double avatarTopPosition = headerHeight - avatarRadius;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Contenido principal que se desplaza (incluye el header y el resto)
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: avatarTopPosition + avatarRadius + 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 96.0,
                    right: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShiningTextAnimation(
                        text: username,
                        style: TextStyles.urbanistH6.copyWith(color: AppColors.shineColorLight),
                        shineColor: AppColors.shineColorLight,
                      ),
                      Text(
                        email,
                        style: TextStyles.plusJakartaSansBody2.copyWith(color: AppColors.textGrey400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                  child: Text(
                    AppStrings.profileYourAccountTitle(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: AppColors.switchInactiveTrackColor),
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildProfileListItem(
                  icon: Icons.person_outline,
                  text: AppStrings.profileEditProfileText(context),
                  isExpandable: true,
                  isExpanded: _isEditProfileExpanded,
                  onToggleExpand: _toggleEditProfile,
                  listBackgroundColor: AppColors.cardBackground,
                  dropdownContent: Text(
                    AppInternalConstants.functionalityNotImplemented,
                    style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.shineEffectColor),
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildProfileListItem(
                  icon: Icons.notifications_none,
                  text: AppStrings.profileNotificationSettingsText(context),
                  isExpandable: true,
                  isExpanded: _isNotificationSettingsExpanded,
                  onToggleExpand: _toggleNotificationSettings,
                  listBackgroundColor: AppColors.cardBackground,
                  dropdownContent: Text(
                    AppInternalConstants.functionalityNotImplemented,
                    style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.shineEffectColor),
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
                  child: Text(
                    AppStrings.profileAppSettingsTitle(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: AppColors.switchInactiveTrackColor),
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildProfileListItem(
                  icon: Icons.color_lens_outlined,
                  text: AppStrings.profileThemesText(context),
                  isExpandable: true,
                  isExpanded: _isThemeColorExpanded,
                  onToggleExpand: _toggleThemeColor,
                  listBackgroundColor: AppColors.cardBackground,
                  dropdownContent: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selecciona un color para el tema:',
                        style: TextStyles.plusJakartaSansBody2.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8.0),
                      DropdownButton<Color?>(
                        value: _selectedColor,
                        dropdownColor: AppColors.dropdownContentBackground,
                        icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
                        underline: Container(
                          height: 1,
                          color: AppColors.textPrimary.withOpacity(0.5),
                        ),
                        isExpanded: true,
                        onChanged: _changeThemeColor,
                        items: _availableColors.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final Color? colorOption = entry.value;
                          final String name = _colorNames[index];

                          return DropdownMenuItem<Color?>(
                            value: colorOption,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: colorOption ?? AppColorPalette.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  name,
                                  style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildProfileListItem(
                  icon: Icons.help_outline_rounded,
                  text: AppStrings.profileSupportText(context),
                  isExpandable: true,
                  isExpanded: _isSupportExpanded,
                  onToggleExpand: _toggleSupport,
                  listBackgroundColor: AppColors.cardBackground,
                  dropdownContent: InkWell(
                    onTap: () => _contactSupport(context),
                    child: Text(
                      AppStrings.profileContactUsText(context),
                      style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.shineEffectColor),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildProfileListItem(
                  icon: Icons.privacy_tip_rounded,
                  text: AppStrings.profileTermsOfServiceText(context),
                  isExpandable: true,
                  isExpanded: _isTermsOfServiceExpanded,
                  onToggleExpand: _toggleTermsOfService,
                  listBackgroundColor: AppColors.cardBackground,
                  dropdownContent: Text(
                    AppInternalConstants.functionalityNotImplemented,
                    style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.shineEffectColor),
                  ),
                ),
                const SizedBox(height: 24.0),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: ElevatedButton(
                    onPressed: () {
                      LogoutService.logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: errorColor,
                      foregroundColor: AppColors.textPrimary,
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: errorColor.withOpacity(0.5),
                    ),
                    child: Text(
                      AppStrings.profileLogoutButton(context),
                      style: TextStyles.plusJakartaSansButton.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
          // 2. Header (se mantiene fijo en la parte superior del Stack) con BLUR y bordes cuadrados
          ClipRRect(
            borderRadius: BorderRadius.zero, // Bordes cuadrados
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.infinity,
                height: headerHeight,
                color: AppColors.profileHeaderBackground.withOpacity(0.80), // Menos transparente
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.profileMediumGrey.withOpacity(0.28), // Menos transparente
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                                onPressed: () => _navigateToCalendarScreen(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 96.0, top: 60.0),
                      child: ShiningTextAnimation(
                        text: currentDate,
                        style: TextStyles.urbanistBody1.copyWith(color: AppColors.shineEffectColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: avatarTopPosition,
            left: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(avatarRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.profileMediumGrey.withOpacity(0.35), // Menos transparente
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.transparent,
                    child: Center(
                      child: Text(
                        _firstLetter,
                        style: TextStyles.urbanistSubtitle1.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileListItem({
    required IconData icon,
    required String text,
    required Color listBackgroundColor,
    required bool isExpandable,
    required bool isExpanded,
    required VoidCallback onToggleExpand,
    required Widget dropdownContent,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          child: InkWell(
            onTap: isExpandable ? onToggleExpand : onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: listBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      icon,
                      color: AppColors.textGrey500,
                      size: 24,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: Text(
                        text,
                        style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0.9, 0),
                        child: Icon(
                          isExpandable
                              ? (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                              : Icons.arrow_forward_ios,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Visibility(
            visible: isExpanded && isExpandable,
            child: Column(
              children: [
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.dropdownContentBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.textSecondary.withOpacity(0.2), width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0.5,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: dropdownContent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}