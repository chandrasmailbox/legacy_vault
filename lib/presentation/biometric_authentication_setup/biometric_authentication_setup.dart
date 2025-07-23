import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/biometric_explanation_widget.dart';
import './widgets/biometric_icon_widget.dart';
import './widgets/security_info_widget.dart';

class BiometricAuthenticationSetup extends StatefulWidget {
  const BiometricAuthenticationSetup({Key? key}) : super(key: key);

  @override
  State<BiometricAuthenticationSetup> createState() =>
      _BiometricAuthenticationSetupState();
}

class _BiometricAuthenticationSetupState
    extends State<BiometricAuthenticationSetup>
    with TickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late AnimationController _checkmarkAnimationController;
  late Animation<double> _iconAnimation;
  late Animation<double> _checkmarkAnimation;

  bool _isSetupComplete = false;
  bool _isLoading = false;
  String _biometricType = 'fingerprint'; // fingerprint, face, iris
  bool _biometricAvailable = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _iconAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _checkmarkAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _iconAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _checkmarkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkmarkAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _iconAnimationController.repeat(reverse: true);
  }

  void _checkBiometricAvailability() {
    // Simulate checking biometric availability
    setState(() {
      _biometricAvailable = true;
      _biometricType = 'fingerprint'; // This would be determined by platform
    });
  }

  Future<void> _enableBiometricAuthentication() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate biometric authentication setup
      await Future.delayed(const Duration(seconds: 2));

      // Simulate success
      if (mounted) {
        setState(() {
          _isSetupComplete = true;
          _isLoading = false;
        });

        _iconAnimationController.stop();
        _checkmarkAnimationController.forward();

        // Auto-navigate after success animation
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/digital-will-setup');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Biometric setup failed. Please try again.';
        });
      }
    }
  }

  void _skipBiometricSetup() {
    Navigator.pushReplacementNamed(context, '/digital-will-setup');
  }

  void _navigateToSettings() {
    // This would open system settings for biometric enrollment
    setState(() {
      _errorMessage =
          'Please enroll your biometric data in device settings first.';
    });
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _checkmarkAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Biometric Setup',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 4.h),

              // Biometric Icon with Animation
              BiometricIconWidget(
                biometricType: _biometricType,
                iconAnimation: _iconAnimation,
                checkmarkAnimation: _checkmarkAnimation,
                isSetupComplete: _isSetupComplete,
              ),

              SizedBox(height: 4.h),

              // Title and Description
              Text(
                _isSetupComplete
                    ? 'Biometric Authentication Enabled!'
                    : 'Secure Your Vault',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.h),

              // Explanation Widget
              BiometricExplanationWidget(
                biometricType: _biometricType,
                isSetupComplete: _isSetupComplete,
              ),

              SizedBox(height: 4.h),

              // Security Information
              SecurityInfoWidget(),

              SizedBox(height: 4.h),

              // Error Message
              if (_errorMessage.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.error.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
              ],

              // Action Buttons
              if (!_isSetupComplete) ...[
                // Enable Biometric Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed:
                        _biometricAvailable && !_isLoading
                            ? _enableBiometricAuthentication
                            : null,
                    style: AppTheme.lightTheme.elevatedButtonTheme.style,
                    child:
                        _isLoading
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName:
                                      _biometricType == 'face'
                                          ? 'face'
                                          : 'fingerprint',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Enable Biometric Authentication',
                                  style: AppTheme
                                      .lightTheme
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color:
                                            AppTheme
                                                .lightTheme
                                                .colorScheme
                                                .onPrimary,
                                      ),
                                ),
                              ],
                            ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Skip Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _skipBiometricSetup,
                    style: AppTheme.lightTheme.outlinedButtonTheme.style,
                    child: Text(
                      'Skip for Now',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Settings Link (if biometric not available)
                if (!_biometricAvailable)
                  TextButton(
                    onPressed: _navigateToSettings,
                    child: Text(
                      'Open Device Settings',
                      style: AppTheme.lightTheme.textTheme.labelMedium
                          ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
              ] else ...[
                // Success State - Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/digital-will-setup',
                        ),
                    style: AppTheme.lightTheme.elevatedButtonTheme.style,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Digital Will Setup',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                        ),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'arrow_forward',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: 4.h),

              // Bottom Information
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Important Information',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '• Your master password remains the primary security method\n'
                      '• Biometric data never leaves your device\n'
                      '• You can always access your vault with your master password\n'
                      '• Inheritance process works regardless of biometric settings',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
