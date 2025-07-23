import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SecurityInfoWidget extends StatelessWidget {
  const SecurityInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'shield',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Security & Privacy',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Security Points
          ..._getSecurityPoints().map((point) => _buildSecurityPoint(point)),

          SizedBox(height: 2.h),

          // Platform Specific Information
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withValues(
                alpha: 0.05,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Platform Security:',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Uses your device\'s secure hardware (iOS Secure Enclave / Android Keystore) for biometric data processing. No biometric information is ever stored or transmitted by Legacy Vault.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    height: 1.4,
                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getSecurityPoints() {
    return [
      {
        'icon': 'lock',
        'text': 'Biometric data stays on your device and never leaves it',
      },
      {
        'icon': 'offline_pin',
        'text': 'Works completely offline - no cloud dependency',
      },
      {
        'icon': 'key',
        'text': 'Master password remains your primary access method',
      },
      {
        'icon': 'family_restroom',
        'text': 'Inheritance process works regardless of biometric settings',
      },
    ];
  }

  Widget _buildSecurityPoint(Map<String, String> point) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.2.h),
            child: CustomIconWidget(
              iconName: point['icon']!,
              color: AppTheme.lightTheme.colorScheme.primary.withValues(
                alpha: 0.7,
              ),
              size: 16,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              point['text']!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                height: 1.4,
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
