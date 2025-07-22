import 'package:flutter/material.dart';

import '../presentation/add_edit_password/add_edit_password.dart';
import '../presentation/biometric_authentication_setup/biometric_authentication_setup.dart';
import '../presentation/digital_will_setup/digital_will_setup.dart';
import '../presentation/family_management/family_management.dart';
import '../presentation/inheritance_status_dashboard/inheritance_status_dashboard.dart';
import '../presentation/master_password_setup/master_password_setup.dart';
import '../presentation/password_vault/password_vault.dart';
import '../presentation/security_settings/security_settings.dart';
import '../presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String biometricAuthenticationSetup =
      '/biometric-authentication-setup';
  static const String passwordVault = '/password-vault';
  static const String familyManagement = '/family-management';
  static const String addEditPassword = '/add-edit-password';
  static const String digitalWillSetup = '/digital-will-setup';
  static const String masterPasswordSetup = '/master-password-setup';
  static const String inheritanceStatusDashboard =
      '/inheritance-status-dashboard';
  static const String securitySettings = '/security-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    biometricAuthenticationSetup: (context) =>
        const BiometricAuthenticationSetup(),
    passwordVault: (context) => const PasswordVault(),
    familyManagement: (context) => const FamilyManagement(),
    addEditPassword: (context) => const AddEditPassword(),
    digitalWillSetup: (context) => const DigitalWillSetup(),
    masterPasswordSetup: (context) => MasterPasswordSetup(),
    inheritanceStatusDashboard: (context) => const InheritanceStatusDashboard(),
    securitySettings: (context) => SecuritySettings(),
    // TODO: Add your other routes here
  };
}
