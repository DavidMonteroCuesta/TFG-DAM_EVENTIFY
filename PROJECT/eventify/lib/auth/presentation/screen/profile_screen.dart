import 'package:eventify/calendar/presentation/screen/calendar_screen.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/utils/auth/logout_service.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/utils/dates/date_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors
import 'package:eventify/common/theme/colors/app_colors_palette.dart'; // IMPORTANT: Add this import!

class ProfileScreen extends StatefulWidget {
  static String routeName = 'profile';
  static String routePath = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables for each dropdown's visibility
  bool _isEditProfileExpanded = false;
  bool _isNotificationSettingsExpanded = false;
  bool _isTermsOfServiceExpanded = false;
  bool _isSupportExpanded = false;
  bool _isThemeColorExpanded = false; // New state for theme color dropdown

  // State variable for the currently selected color in the dropdown
  Color? _selectedColor; // Will be null if "Predeterminado" is selected

  // List of available colors for the user to choose from in the dropdown
  final List<Map<String, dynamic>> _colorOptions = [
    // Added "Predeterminado" option with null color
    {'name': 'Predeterminado', 'color': null},
    {'name': 'Verde', 'color': AppColorPalette.greenAccent}, // No longer "(Default)"
    {'name': 'Azul', 'color': AppColorPalette.blueAccent},
    {'name': 'Naranja', 'color': AppColorPalette.orangeAccent},
    {'name': 'Rojo', 'color': AppColorPalette.redAccent},
    // Removed 'Púrpura' as requested
  ];

  @override
  void initState() {
    super.initState();
    // Initialize _selectedColor directly from AppColors.currentUserSelectedColor.
    // If AppColors.currentUserSelectedColor is null (no user selection),
    // _selectedColor will correctly be null, matching the "Predeterminado" option.
    _selectedColor = AppColors.currentUserSelectedColor;
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

  // Toggle functions for each dropdown
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

  void _toggleThemeColor() { // New toggle function for theme color
    setState(() {
      _isThemeColorExpanded = !_isThemeColorExpanded;
    });
  }

  void _changeThemeColor(Color? newColor) {
    // newColor can now be null if "Predeterminado" is selected
    setState(() {
      _selectedColor = newColor; // Update the dropdown's selected value
      AppColors.currentUserSelectedColor = newColor; // Update the static global color to null if "Predeterminado"
    });
    // Optionally, show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Color de tema cambiado.'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.snackBarInfoColor,
      ),
    );
    // NOTE: Because AppColors uses static getters, this setState() call
    // is what triggers the ProfileScreen to rebuild and use the new colors.
    // Other parts of your app would need similar rebuild triggers.
  }

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.profileContactUsText(context)),
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.snackBarInfoColor, // Using AppColors
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error; // Keeping this as it's theme-derived
    final currentDate = DateFormatter.getCurrentDateFormatted();

    final user = FirebaseAuth.instance.currentUser;

    final username = user?.displayName ?? AppInternalConstants.profileUsernameDefault;
    final email = user?.email ?? AppInternalConstants.profileEmailDefault;

    final bool isMobile = Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS;

    final double topPadding = isMobile ? 120.0 : 80.0;
    final double usernameTopPadding = isMobile ? 56.0 : 16.0;

    return Scaffold(
      backgroundColor: AppColors.background, // Using AppColors
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                height: 120,
                color: AppColors.profileHeaderBackground, // Using AppColors
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 20.0),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textSecondary), // Using AppColors
                          onPressed: () => _navigateToCalendarScreen(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 96.0, top: 60.0),
                      child: ShiningTextAnimation(
                        text: currentDate,
                        style: TextStyles.urbanistBody1.copyWith(color: AppColors.shineEffectColor), // Using AppColors
                      ),
                    ),
                  ],
                ),
              ),
              // User Info Section
              Padding(
                padding: EdgeInsets.only(
                  left: 96.0,
                  top: usernameTopPadding,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShiningTextAnimation(
                      text: username,
                      style: TextStyles.urbanistH6.copyWith(color: AppColors.shineEffectColor), // Using AppColors
                      shineColor: AppColors.shineColorLight, // Using AppColors
                    ),
                    Text(
                      email,
                      style: TextStyles.plusJakartaSansBody2.copyWith(color: AppColors.textGrey400), // Using AppColors
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Your Account Section Title
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                child: Text(
                  AppStrings.profileYourAccountTitle(context),
                  style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: AppColors.switchInactiveTrackColor), // Using AppColors
                ),
              ),
              const SizedBox(height: 8.0),

              // Edit Profile Item
              _buildProfileListItem(
                icon: Icons.person_outline,
                text: AppStrings.profileEditProfileText(context),
                isExpandable: true,
                isExpanded: _isEditProfileExpanded,
                onToggleExpand: _toggleEditProfile,
                listBackgroundColor: AppColors.cardBackground, // Using AppColors
                dropdownContent: Text(
                  AppInternalConstants.functionalityNotImplemented,
                  style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.shineEffectColor), // Using AppColors
                ),
              ),
              const SizedBox(height: 8.0),

              // Notification Settings Item
              _buildProfileListItem(
                icon: Icons.notifications_none,
                text: AppStrings.profileNotificationSettingsText(context),
                isExpandable: true,
                isExpanded: _isNotificationSettingsExpanded,
                onToggleExpand: _toggleNotificationSettings,
                listBackgroundColor: AppColors.cardBackground, // Using AppColors
                dropdownContent: Text(
                  AppInternalConstants.functionalityNotImplemented,
                  style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.shineEffectColor), // Using AppColors
                ),
              ),
              const SizedBox(height: 24.0),

              // App Settings Section Title
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
                child: Text(
                  AppStrings.profileAppSettingsTitle(context),
                  style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: AppColors.switchInactiveTrackColor), // Using AppColors
                ),
              ),
              const SizedBox(height: 8.0),

              // NEW: Theme Color Selection Item
              _buildProfileListItem(
                icon: Icons.color_lens_outlined,
                text: AppStrings.profileThemesText(context),
                isExpandable: true,
                isExpanded: _isThemeColorExpanded,
                onToggleExpand: _toggleThemeColor,
                listBackgroundColor: AppColors.cardBackground, // Using AppColors
                dropdownContent: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selecciona un color para el tema:',
                      style: TextStyles.plusJakartaSansBody2.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButton<Color>(
                      value: _selectedColor,
                      dropdownColor: AppColors.dropdownContentBackground, // Using AppColors
                      icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary), // Using AppColors
                      underline: Container(
                        height: 1,
                        color: AppColors.textPrimary.withOpacity(0.5), // Using AppColors
                      ),
                      isExpanded: true,
                      onChanged: _changeThemeColor,
                      items: _colorOptions.map<DropdownMenuItem<Color>>((Map<String, dynamic> option) {
                        return DropdownMenuItem<Color>(
                          value: option['color'] as Color?, // Cast to Color? as it can now be null
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: (option['color'] as Color?) ?? AppColorPalette.grey, // Show grey for "Predeterminado" swatch
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                option['name'] as String,
                                style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.textPrimary), // Using AppColors
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


              // Support Section with Dropdown
              _buildProfileListItem(
                icon: Icons.help_outline_rounded,
                text: AppStrings.profileSupportText(context),
                isExpandable: true,
                isExpanded: _isSupportExpanded,
                onToggleExpand: _toggleSupport,
                listBackgroundColor: AppColors.cardBackground, // Using AppColors
                dropdownContent: InkWell(
                  onTap: () => _contactSupport(context),
                  child: Text(
                    AppStrings.profileContactUsText(context),
                    style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.shineEffectColor), // Using AppColors
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // Terms of Service Item
              _buildProfileListItem(
                icon: Icons.privacy_tip_rounded,
                text: AppStrings.profileTermsOfServiceText(context),
                isExpandable: true,
                isExpanded: _isTermsOfServiceExpanded,
                onToggleExpand: _toggleTermsOfService,
                listBackgroundColor: AppColors.cardBackground, // Using AppColors
                dropdownContent: Text(
                  AppInternalConstants.functionalityNotImplemented,
                  style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.shineEffectColor), // Using AppColors
                ),
              ),
              const SizedBox(height: 24.0),

              // Log Out Button
              Align(
                alignment: AlignmentDirectional.center,
                child: ElevatedButton(
                  onPressed: () {
                    LogoutService.logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: errorColor, // Keeping this as it's theme-derived
                    foregroundColor: AppColors.textPrimary, // Using AppColors
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: errorColor.withOpacity(0.5), // Keeping this as it's theme-derived
                  ),
                  child: Text(
                    AppStrings.profileLogoutButton(context),
                    style: TextStyles.plusJakartaSansButton.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          // Profile Picture CircleAvatar
          Positioned(
            top: topPadding,
            left: 16,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.profileMediumGrey, // Using AppColors
              child: Center(
                child: Text(
                  _firstLetter,
                  style: TextStyles.urbanistSubtitle1.copyWith(color: AppColors.textPrimary, fontSize: 32), // Using AppColors
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for consistent list item styling with optional dropdown
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
                    color: Colors.black.withOpacity(0.1), // Derived color, keep as is
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
                      color: AppColors.textGrey500, // Using AppColors
                      size: 24,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: Text(
                        text,
                        style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.textPrimary), // Using AppColors
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0.9, 0),
                        child: Icon(
                          isExpandable
                              ? (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                              : Icons.arrow_forward_ios,
                          color: AppColors.textSecondary, // Using AppColors
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
                      color: AppColors.dropdownContentBackground, // Using AppColors
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.textSecondary.withOpacity(0.2), width: 0.5), // Using AppColors
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Derived color, keep as is
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