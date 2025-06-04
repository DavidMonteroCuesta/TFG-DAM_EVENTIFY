// ignore_for_file: deprecated_member_use

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
import 'package:eventify/common/theme/colors/app_colors_palette.dart';
import 'package:eventify/common/constants/app_routes.dart';
import 'package:eventify/auth/presentation/screen/profile/widgets/profile_list_item.dart';
import 'package:eventify/auth/presentation/screen/profile/logic/profile_theme_logic.dart';
import 'package:eventify/auth/presentation/screen/profile/widgets/profile_header.dart';
import 'package:eventify/auth/presentation/screen/profile/widgets/profile_avatar.dart';

const double kProfileHeaderHeight = 120.0;
const double kProfileAvatarRadius = 40.0;
const double kProfileAvatarTopOffset =
    kProfileHeaderHeight - kProfileAvatarRadius;
const double kProfilePaddingLeft = 96.0;
const double kProfilePaddingRight = 16.0;
const double kProfileSectionSpacing = 24.0;
const double kProfileSectionTitlePaddingTop = 4.0;
const double kProfileSectionTitlePaddingLeft = 24.0;
const double kProfileSectionTitlePaddingBottom = 0.0;
const double kProfileSectionTitlePaddingRight = 0.0;
const double kProfileListItemSpacing = 8.0;
const double kProfileDropdownCircleSize = 20.0;
const double kProfileDropdownCircleSpacing = 8.0;
const double kProfileLogoutButtonWidth = 200.0;
const double kProfileLogoutButtonHeight = 50.0;
const double kProfileLogoutButtonRadius = 12.0;
const double kProfileLogoutButtonElevation = 5.0;
const double kProfileLogoutButtonShadowOpacity = 0.5;
const double kProfileLogoutButtonFontSize = 16.0;
const double kProfileAvatarTopPadding = 16.0;

class ProfileScreen extends StatefulWidget {
  static String routeName = AppRoutes.profile;
  static String routePath = AppRoutes.profile;

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

  final List<Color?> _availableColors = ProfileThemeLogic.availableColors;
  List<String> get _colorNames => ProfileThemeLogic.colorNames(context);

  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    Color? currentAppThemeColor = AppColors.secondaryDynamic;
    Color? matchedDropdownValue = ProfileThemeLogic.getMatchedDropdownValue(
      currentAppThemeColor,
    );

    _selectedColor = matchedDropdownValue;
    if (currentAppThemeColor == AppColorPalette.greenAccent &&
        _selectedColor != null) {
      _selectedColor = null;
    }
  }

  String get _firstLetter {
    final user = FirebaseAuth.instance.currentUser;
    final username =
        user?.displayName ?? AppInternalConstants.profileUsernameDefault;
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
    final username =
        user?.displayName ?? AppInternalConstants.profileUsernameDefault;
    final email = user?.email ?? AppInternalConstants.profileEmailDefault;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top:
                  kProfileAvatarTopOffset +
                  kProfileAvatarRadius +
                  kProfileAvatarTopPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: kProfilePaddingLeft,
                    right: kProfilePaddingRight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShiningTextAnimation(
                        text: username,
                        style: TextStyles.urbanistH6.copyWith(
                          color: AppColors.shineColorLight,
                        ),
                        shineColor: AppColors.shineColorLight,
                      ),
                      Text(
                        email,
                        style: TextStyles.plusJakartaSansBody2.copyWith(
                          color: AppColors.textGrey400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kProfileSectionSpacing),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    kProfileSectionTitlePaddingLeft,
                    kProfileSectionTitlePaddingTop,
                    kProfileSectionTitlePaddingRight,
                    kProfileSectionTitlePaddingBottom,
                  ),
                  child: Text(
                    AppStrings.profileYourAccountTitle(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(
                      color: AppColors.switchInactiveTrackColor,
                    ),
                  ),
                ),
                // Espaciado entre secciones del perfil
                SizedBox(height: kProfileListItemSpacing),
                // Ítem para editar el perfil
                ProfileListItem(
                  icon: Icons.person_outline,
                  text: AppStrings.profileEditProfileText(context),
                  isExpandable: true,
                  isExpanded: _isEditProfileExpanded,
                  onToggleExpand: _toggleEditProfile,
                  listBackgroundColor: AppColors.cardBackground,
                  dropdownContent: Text(
                    AppInternalConstants.functionalityNotImplemented,
                    style: TextStyles.plusJakartaSansBody1.copyWith(
                      color: AppColors.shineEffectColor,
                    ),
                  ),
                ),
                // Espaciado entre ítems
                SizedBox(height: kProfileListItemSpacing),
                // Ítem para notificaciones
                ProfileListItem(
                  icon: Icons.notifications_none,
                  text: AppStrings.profileNotificationSettingsText(context),
                  isExpandable: true,
                  isExpanded: _isNotificationSettingsExpanded,
                  onToggleExpand: _toggleNotificationSettings,
                  listBackgroundColor: AppColors.cardBackground,
                  dropdownContent: Text(
                    AppInternalConstants.functionalityNotImplemented,
                    style: TextStyles.plusJakartaSansBody1.copyWith(
                      color: AppColors.shineEffectColor,
                    ),
                  ),
                ),
                // Espaciado entre secciones del perfil
                SizedBox(height: kProfileSectionSpacing),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    kProfileSectionTitlePaddingLeft,
                    16,
                    kProfileSectionTitlePaddingRight,
                    kProfileSectionTitlePaddingBottom,
                  ),
                  child: Text(
                    AppStrings.profileAppSettingsTitle(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(
                      color: AppColors.switchInactiveTrackColor,
                    ),
                  ),
                ),
                // Espaciado entre ítems
                SizedBox(height: kProfileListItemSpacing),
                // Ítem para temas de color
                ProfileListItem(
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
                        AppStrings.profileThemeSelectColorLabel(context),
                        style: TextStyles.plusJakartaSansBody2.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: kProfileDropdownCircleSpacing),
                      DropdownButton<Color?>(
                        value: _selectedColor,
                        dropdownColor: AppColors.dropdownContentBackground,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textPrimary,
                        ),
                        underline: Container(
                          height: 1,
                          color: AppColors.textPrimary.withOpacity(0.5),
                        ),
                        isExpanded: true,
                        onChanged: _changeThemeColor,
                        items:
                            _availableColors.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final Color? colorOption = entry.value;
                              final String name = _colorNames[index];

                              return DropdownMenuItem<Color?>(
                                value: colorOption,
                                child: Row(
                                  children: [
                                    Container(
                                      width: kProfileDropdownCircleSize,
                                      height: kProfileDropdownCircleSize,
                                      decoration: BoxDecoration(
                                        color:
                                            colorOption ?? AppColorPalette.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: kProfileDropdownCircleSpacing,
                                    ),
                                    Text(
                                      name,
                                      style: TextStyles.plusJakartaSansBody1
                                          .copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
                // Espaciado entre ítems
                SizedBox(height: kProfileListItemSpacing),
                // Ítem para soporte
                ProfileListItem(
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
                      style: TextStyles.plusJakartaSansBody1.copyWith(
                        color: AppColors.shineEffectColor,
                      ),
                    ),
                  ),
                ),
                // Espaciado entre ítems
                SizedBox(height: kProfileListItemSpacing),
                // Ítem para términos de servicio
                ProfileListItem(
                  icon: Icons.privacy_tip_rounded,
                  text: AppStrings.profileTermsOfServiceText(context),
                  isExpandable: true,
                  isExpanded: _isTermsOfServiceExpanded,
                  onToggleExpand: _toggleTermsOfService,
                  listBackgroundColor: AppColors.cardBackground,
                  dropdownContent: Text(
                    AppInternalConstants.functionalityNotImplemented,
                    style: TextStyles.plusJakartaSansBody1.copyWith(
                      color: AppColors.shineEffectColor,
                    ),
                  ),
                ),
                // Espaciado antes del botón de logout
                SizedBox(height: kProfileSectionSpacing),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: ElevatedButton(
                    onPressed: () {
                      LogoutService.logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: errorColor,
                      foregroundColor: AppColors.textPrimary,
                      fixedSize: const Size(
                        kProfileLogoutButtonWidth,
                        kProfileLogoutButtonHeight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          kProfileLogoutButtonRadius,
                        ),
                      ),
                      elevation: kProfileLogoutButtonElevation,
                      shadowColor: errorColor.withOpacity(
                        kProfileLogoutButtonShadowOpacity,
                      ),
                    ),
                    child: Text(
                      AppStrings.profileLogoutButton(context),
                      style: TextStyles.plusJakartaSansButton.copyWith(
                        fontSize: kProfileLogoutButtonFontSize,
                      ),
                    ),
                  ),
                ),
                // Espaciado final
                SizedBox(height: kProfileSectionSpacing),
              ],
            ),
          ),
          ProfileHeader(
            currentDate: currentDate,
            onClose: () => _navigateToCalendarScreen(context),
            headerHeight: kProfileHeaderHeight,
          ),
          ProfileAvatar(
            firstLetter: _firstLetter,
            avatarRadius: kProfileAvatarRadius,
            avatarTopPosition: kProfileAvatarTopOffset,
          ),
        ],
      ),
    );
  }
}
