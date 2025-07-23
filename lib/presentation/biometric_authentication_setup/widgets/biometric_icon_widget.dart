import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class BiometricIconWidget extends StatelessWidget {
  final String biometricType;
  final Animation<double> iconAnimation;
  final Animation<double> checkmarkAnimation;
  final bool isSetupComplete;

  const BiometricIconWidget({
    Key? key,
    required this.biometricType,
    required this.iconAnimation,
    required this.checkmarkAnimation,
    required this.isSetupComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Biometric Icon
          if (!isSetupComplete)
            AnimatedBuilder(
              animation: iconAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: iconAnimation.value,
                  child: CustomIconWidget(
                    iconName: _getBiometricIconName(),
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 12.w,
                  ),
                );
              },
            ),

          // Success Checkmark
          if (isSetupComplete)
            AnimatedBuilder(
              animation: checkmarkAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: checkmarkAnimation.value,
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 8.w,
                    ),
                  ),
                );
              },
            ),

          // Pulse Effect
          if (!isSetupComplete)
            AnimatedBuilder(
              animation: iconAnimation,
              builder: (context, child) {
                return Container(
                  width: 30.w * (0.8 + (iconAnimation.value - 0.8) * 2),
                  height: 30.w * (0.8 + (iconAnimation.value - 0.8) * 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary.withValues(
                        alpha: 0.3 * (1 - (iconAnimation.value - 0.8) * 5),
                      ),
                      width: 1,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _getBiometricIconName() {
    switch (biometricType) {
      case 'face':
        return 'face';
      case 'iris':
        return 'visibility';
      case 'fingerprint':
      default:
        return 'fingerprint';
    }
  }
}
