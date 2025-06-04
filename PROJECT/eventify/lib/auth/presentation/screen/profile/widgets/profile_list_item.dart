// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

const double kProfileListItemBorderRadius = 12.0;
const double kProfileListItemHeight = 60.0;
const double kProfileListItemBoxShadowOpacity = 0.1;
const double kProfileListItemBoxShadowSpread = 0.5;
const double kProfileListItemBoxShadowBlur = 3.0;
const double kProfileListItemBoxShadowOffsetY = 2.0;
const double kProfileListItemIconSize = 24.0;
const double kProfileListItemPadding = 12.0;
const double kProfileListItemDropdownPaddingH = 16.0;
const double kProfileListItemDropdownPaddingV = 12.0;
const double kProfileListItemDropdownBorderWidth = 0.5;
const double kProfileListItemDropdownRadius = 12.0;
const double kProfileListItemDropdownBoxShadowOpacity = 0.1;
const double kProfileListItemDropdownBoxShadowSpread = 0.5;
const double kProfileListItemDropdownBoxShadowBlur = 3.0;
const double kProfileListItemDropdownBoxShadowOffsetY = 2.0;
const double kProfileListItemDropdownSpacing = 5.0;
const double kProfileListItemTextPadding = 12.0;
const double kProfileListItemDropdownAlignX = 0.9;
const double kProfileListItemPaddingHorizontal = 16.0;
const double kProfileListItemDropdownPaddingHorizontal = 16.0;
const double kProfileListItemDropdownPaddingVertical = 0.0;
const double kProfileListItemDropdownContainerWidth = double.infinity;
const double kProfileListItemDropdownContainerBorderOpacity = 0.2;
const int kProfileListItemDropdownAnimationDurationMs = 300;

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
          padding: EdgeInsetsDirectional.fromSTEB(
            kProfileListItemPaddingHorizontal,
            0,
            kProfileListItemPaddingHorizontal,
            0,
          ),
          child: InkWell(
            onTap: isExpandable ? onToggleExpand : onTap,
            borderRadius: BorderRadius.circular(kProfileListItemBorderRadius),
            child: Container(
              width: double.infinity,
              height: kProfileListItemHeight,
              decoration: BoxDecoration(
                color: listBackgroundColor,
                borderRadius: BorderRadius.circular(
                  kProfileListItemBorderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      kProfileListItemBoxShadowOpacity,
                    ),
                    spreadRadius: kProfileListItemBoxShadowSpread,
                    blurRadius: kProfileListItemBoxShadowBlur,
                    offset: Offset(0, kProfileListItemBoxShadowOffsetY),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(kProfileListItemPadding),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      icon,
                      color: AppColors.textGrey500,
                      size: kProfileListItemIconSize,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        kProfileListItemTextPadding,
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
                        alignment: AlignmentDirectional(
                          kProfileListItemDropdownAlignX,
                          0,
                        ),
                        child: Icon(
                          isExpandable
                              ? (isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down)
                              : Icons.arrow_forward_ios,
                          color: AppColors.textSecondary,
                          size: kProfileListItemIconSize,
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
          duration: Duration(
            milliseconds: kProfileListItemDropdownAnimationDurationMs,
          ),
          curve: Curves.easeInOut,
          child: Visibility(
            visible: isExpanded && isExpandable,
            child: Column(
              children: [
                SizedBox(height: kProfileListItemDropdownSpacing),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    kProfileListItemDropdownPaddingHorizontal,
                    kProfileListItemDropdownPaddingVertical,
                    kProfileListItemDropdownPaddingHorizontal,
                    kProfileListItemDropdownPaddingVertical,
                  ),
                  child: Container(
                    width: kProfileListItemDropdownContainerWidth,
                    decoration: BoxDecoration(
                      color: AppColors.dropdownContentBackground,
                      borderRadius: BorderRadius.circular(
                        kProfileListItemDropdownRadius,
                      ),
                      border: Border.all(
                        color: AppColors.textSecondary.withOpacity(
                          kProfileListItemDropdownContainerBorderOpacity,
                        ),
                        width: kProfileListItemDropdownBorderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            kProfileListItemDropdownBoxShadowOpacity,
                          ),
                          spreadRadius: kProfileListItemDropdownBoxShadowSpread,
                          blurRadius: kProfileListItemDropdownBoxShadowBlur,
                          offset: Offset(
                            0,
                            kProfileListItemDropdownBoxShadowOffsetY,
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: kProfileListItemDropdownPaddingH,
                      vertical: kProfileListItemDropdownPaddingV,
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
