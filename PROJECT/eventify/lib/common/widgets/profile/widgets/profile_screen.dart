import 'package:eventify/calendar/presentation/screen/calendar_screen.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/utils/auth/logout_service.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/utils/dates/date_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = 'profile';
  static String routePath = '/profile';

  const ProfileScreen({super.key});

  String get _firstLetter {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? 'Usuario';
    return username.isNotEmpty ? username[0].toUpperCase() : '';
  }

  void _navigateToCalendarScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    const listBackgroundColor = Color(0xFF1F1F1F);
    const mediumGreyColor = Color.fromARGB(255, 70, 70, 70);
    const headerBackgroundColor = Color.fromARGB(255, 49, 49, 49);
    final currentDate = DateFormatter.getCurrentDateFormatted();

    final user = FirebaseAuth.instance.currentUser;

    final username = user?.displayName ?? 'Usuario';
    final email = user?.email ?? 'email@dominio.com';

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
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    color: headerBackgroundColor,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => _navigateToCalendarScreen(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 96.0, top: 40),
                    // Usa el padding superior calculado
                    child: ShiningTextAnimation(
                      text: currentDate,
                      style: TextStyles.urbanistBody1,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 96.0,
                  top: usernameTopPadding,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyles.urbanistH6,
                    ),
                    Text(
                      email,
                      style: TextStyles.plusJakartaSansBody2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                child: Text(
                  'Your Account',
                  style: TextStyles.plusJakartaSansSubtitle2,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: listBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 0, 0, 0),
                          child: Text(
                            'Edit Profile',
                            style: TextStyles.plusJakartaSansBody1,
                          ),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.9, 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: listBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 0, 0, 0),
                          child: Text(
                            'Notification Settings',
                            style: TextStyles.plusJakartaSansBody1,
                          ),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.9, 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
                child: Text(
                  'App Settings',
                  style: TextStyles.plusJakartaSansSubtitle2,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: listBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.help_outline_rounded,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 0, 0, 0),
                          child: Text(
                            'Support',
                            style: TextStyles.plusJakartaSansBody1,
                          ),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.9, 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: listBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.privacy_tip_rounded,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 0, 0, 0),
                          child: Text(
                            'Terms of Service',
                            style: TextStyles.plusJakartaSansBody1,
                          ),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.9, 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      LogoutService.logout(
                        context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: errorColor,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(150, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyles.plusJakartaSansButton,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: topPadding,
            left: 16,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: mediumGreyColor,
              child: Center(
                child: Text(
                  _firstLetter,
                  style: TextStyles.urbanistSubtitle1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

