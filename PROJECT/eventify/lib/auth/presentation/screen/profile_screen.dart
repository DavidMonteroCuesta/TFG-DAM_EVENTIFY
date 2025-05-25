import 'package:eventify/calendar/presentation/screen/calendar_screen.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/utils/auth/logout_service.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/utils/dates/date_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_strings.dart';

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
  bool _isSupportExpanded = false; // Renamed for consistency

  String get _firstLetter {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? AppStrings.profileUsernameDefault; // Using constant
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

  void _toggleSupport() { // Renamed from _toggleSupportDropdown
    setState(() {
      _isSupportExpanded = !_isSupportExpanded;
    });
  }

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.profileContactUsText), // Using constant
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    const listBackgroundColor = Color(0xFF1F1F1F);
    const mediumGreyColor = Color.fromARGB(255, 70, 70, 70);
    const headerBackgroundColor = Color.fromARGB(255, 30, 30, 30);
    final currentDate = DateFormatter.getCurrentDateFormatted();

    final user = FirebaseAuth.instance.currentUser;

    final username = user?.displayName ?? AppStrings.profileUsernameDefault; // Using constant
    final email = user?.email ?? AppStrings.profileEmailDefault; // Using constant

    final bool isMobile = Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS;

    final double topPadding = isMobile ? 120.0 : 80.0;
    final double usernameTopPadding = isMobile ? 56.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                height: 120,
                color: headerBackgroundColor,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 20.0),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => _navigateToCalendarScreen(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 96.0, top: 60.0),
                      child: ShiningTextAnimation(
                        text: currentDate,
                        style: TextStyles.urbanistBody1.copyWith(color: Colors.white70),
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
                    // MODIFIED: Applied ShiningTextAnimation to the username with matching colors
                    ShiningTextAnimation(
                      text: username,
                      style: TextStyles.urbanistH6.copyWith(color: Colors.white70), // Matched color to currentDate
                      shineColor: const Color(0xFFCBCBCB), // Added explicit shineColor for consistency
                    ),
                    Text(
                      email,
                      style: TextStyles.plusJakartaSansBody2.copyWith(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Your Account Section Title
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                child: Text(
                  AppStrings.profileYourAccountTitle, // Using constant
                  style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 8.0),

              // Edit Profile Item
              _buildProfileListItem(
                icon: Icons.person_outline,
                text: AppStrings.profileEditProfileText, // Using constant
                isExpandable: true,
                isExpanded: _isEditProfileExpanded,
                onToggleExpand: _toggleEditProfile,
                listBackgroundColor: listBackgroundColor,
                dropdownContent: Text(
                  AppStrings.functionalityNotImplemented, // Using constant
                  style: TextStyles.plusJakartaSansBody1.copyWith(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 8.0),

              // Notification Settings Item
              _buildProfileListItem(
                icon: Icons.notifications_none,
                text: AppStrings.profileNotificationSettingsText, // Using constant
                isExpandable: true,
                isExpanded: _isNotificationSettingsExpanded,
                onToggleExpand: _toggleNotificationSettings,
                listBackgroundColor: listBackgroundColor,
                dropdownContent: Text(
                  AppStrings.functionalityNotImplemented, // Using constant
                  style: TextStyles.plusJakartaSansBody1.copyWith(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24.0),

              // App Settings Section Title
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
                child: Text(
                  AppStrings.profileAppSettingsTitle, // Using constant
                  style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 8.0),

              // Support Section with Dropdown
              _buildProfileListItem(
                icon: Icons.help_outline_rounded,
                text: AppStrings.profileSupportText, // Using constant
                isExpandable: true,
                isExpanded: _isSupportExpanded,
                onToggleExpand: _toggleSupport,
                listBackgroundColor: listBackgroundColor,
                dropdownContent: InkWell(
                  onTap: () => _contactSupport(context),
                  child: Text(
                    AppStrings.profileContactUsText, // Using constant
                    style: TextStyles.plusJakartaSansBody1.copyWith(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // Terms of Service Item
              _buildProfileListItem(
                icon: Icons.privacy_tip_rounded,
                text: AppStrings.profileTermsOfServiceText, // Using constant
                isExpandable: true,
                isExpanded: _isTermsOfServiceExpanded,
                onToggleExpand: _toggleTermsOfService,
                listBackgroundColor: listBackgroundColor,
                dropdownContent: Text(
                  AppStrings.functionalityNotImplemented, // Using constant
                  style: TextStyles.plusJakartaSansBody1.copyWith(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24.0),

              // Log Out Button (functionality is already implemented)
              Align(
                alignment: AlignmentDirectional.center,
                child: ElevatedButton(
                  onPressed: () {
                    LogoutService.logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: errorColor,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: errorColor.withOpacity(0.5),
                  ),
                  child: Text(
                    AppStrings.profileLogoutButton, // Using constant
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
              backgroundColor: mediumGreyColor,
              child: Center(
                child: Text(
                  _firstLetter,
                  style: TextStyles.urbanistSubtitle1.copyWith(color: Colors.white, fontSize: 32),
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
    required Widget dropdownContent, // Content to show when expanded
    VoidCallback? onTap, // Optional original onTap for non-expandable items
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          child: InkWell(
            onTap: isExpandable ? onToggleExpand : onTap, // Use onToggleExpand if expandable, else original onTap
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
                      color: Colors.grey.shade500,
                      size: 24,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: Text(
                        text,
                        style: TextStyles.plusJakartaSansBody1.copyWith(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0.9, 0),
                        child: Icon(
                          isExpandable
                              ? (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                              : Icons.arrow_forward_ios, // Keep forward arrow for non-expandable
                          color: Colors.grey,
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
            visible: isExpanded && isExpandable, // Only visible if expandable and expanded
            child: Column(
              children: [
                const SizedBox(height: 5.0), // Separation between main item and dropdown content
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A), // Slightly lighter grey
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
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
