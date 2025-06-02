// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color listBackgroundColor;
  final bool isExpandable;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final Widget dropdownContent;
  final VoidCallback? onTap;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.text,
    required this.listBackgroundColor,
    required this.isExpandable,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.dropdownContent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                    Icon(icon, color: AppColors.textGrey500, size: 24),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        12,
                        0,
                        0,
                        0,
                      ),
                      child: Text(
                        text,
                        style: TextStyles.plusJakartaSansBody1.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0.9, 0),
                        child: Icon(
                          isExpandable
                              ? (isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down)
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
                      border: Border.all(
                        color: AppColors.textSecondary.withOpacity(0.2),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0.5,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
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
