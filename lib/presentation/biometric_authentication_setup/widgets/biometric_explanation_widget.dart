import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricExplanationWidget extends StatelessWidget {
  final String biometricType;
  final bool isSetupComplete;

  const BiometricExplanationWidget({
    Key? key,
    required this.biometricType,
    required this.isSetupComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Description
        Text(
          isSetupComplete ? _getSuccessDescription() : _getSetupDescription(),
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 3.h),

        // Feature Benefits
        if (!isSetupComplete) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Benefits of Biometric Authentication:',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                ..._getBenefitsList()
                    .map((benefit) => _buildBenefitItem(benefit)),
              ],
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Your vault is now secured with both your master password and biometric authentication. You can use either method to access your passwords.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getSetupDescription() {
    String biometricName = _getBiometricDisplayName();
    return 'Add $biometricName authentication for quick and secure access to your password vault. This supplements your master password without replacing it, maintaining your offline security model.';
  }

  String _getSuccessDescription() {
    String biometricName = _getBiometricDisplayName();
    return '$biometricName authentication has been successfully enabled! You can now use either your master password or $biometricName to access your vault.';
  }

  String _getBiometricDisplayName() {
    switch (biometricType) {
      case 'face':
        return 'Face ID';
      case 'iris':
        return 'Iris';
      case 'fingerprint':
      default:
        return 'Fingerprint';
    }
  }

  List<String> _getBenefitsList() {
    return [
      'Quick access without typing your master password',
      'Enhanced security with device-level biometric protection',
      'Convenient unlocking while maintaining privacy',
      'Master password remains as backup access method',
    ];
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            child: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 16,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              benefit,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
