import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityRequirementsWidget extends StatelessWidget {
  final bool hasMinLength;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumbers;
  final bool hasSymbols;

  const SecurityRequirementsWidget({
    super.key,
    required this.hasMinLength,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumbers,
    required this.hasSymbols,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha(128),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Requirements',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          _buildRequirement(
            'At least 12 characters',
            hasMinLength,
          ),
          _buildRequirement(
            'Uppercase letters (A-Z)',
            hasUpperCase,
          ),
          _buildRequirement(
            'Lowercase letters (a-z)',
            hasLowerCase,
          ),
          _buildRequirement(
            'Numbers (0-9)',
            hasNumbers,
          ),
          _buildRequirement(
            'Special symbols (!@#\$%...)',
            hasSymbols,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isMet ? 'check_circle' : 'radio_button_unchecked',
            color: isMet
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withAlpha(128),
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isMet
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                decoration: isMet ? null : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
