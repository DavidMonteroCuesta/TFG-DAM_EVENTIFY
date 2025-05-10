import 'package:eventify/common/utils/auth/logout_service.dart';
import 'package:eventify/auth/domain/presentation/screen/animations/ani_shining_text.dart';
import 'package:eventify/common/widgets/calendar/widgets/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final listBackgroundColor = const Color(0xFF1F1F1F);
    final mediumGreyColor = const Color.fromARGB(255, 70, 70, 70);
    final headerBackgroundColor = const Color.fromARGB(255, 49, 49, 49);
    final currentDate = DateFormatter.getCurrentDateFormatted();

    final user = FirebaseAuth.instance.currentUser;

    final username = user?.displayName ?? 'Usuario';
    final email = user?.email ?? 'email@dominio.com';

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
                    height: 80,
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
                    padding: const EdgeInsets.only(left: 96.0),
                    child: ShiningTextAnimation(
                      text: currentDate,
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: const Color.fromARGB(255, 131, 131, 131),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 96.0,
                  top: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      email, // Use the user's email
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                child: Text(
                  'Your Account',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey.shade500,
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
                          Icons.person_outline,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Notification Settings',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey.shade500,
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
                          Icons.help_outline_rounded,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Support',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Terms of Service',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: mediumGreyColor,
              child: Center(
                child: Text(
                  _firstLetter,
                  style: GoogleFonts.urbanist(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
