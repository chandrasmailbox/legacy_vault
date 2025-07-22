import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/authentication_settings_widget.dart';
import './widgets/auto_lock_settings_widget.dart';
import './widgets/emergency_access_widget.dart';
import './widgets/encryption_settings_widget.dart';
import './widgets/privacy_settings_widget.dart';
import './widgets/security_audit_widget.dart';

class SecuritySettings extends StatefulWidget {
  const SecuritySettings({super.key});

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  bool _biometricEnabled = true;
  bool _screenCaptureProtection = true;
  bool _secureKeyboard = false;
  bool _dataCollection = false;
  bool _crashReporting = true;
  int _sessionTimeout = 15;
  int _autoLockInterval = 5;
  String _encryptionAlgorithm = 'AES-256';
  int _pbkdf2Iterations = 100000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Security Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showSecurityHelp(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Overview Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.security,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security Status: Strong',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 1.w),
                          Text(
                            'Your vault is well-protected with multiple security layers',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 6.w),

            // Authentication Settings
            AuthenticationSettingsWidget(
              biometricEnabled: _biometricEnabled,
              sessionTimeout: _sessionTimeout,
              onBiometricChanged: (value) {
                setState(() {
                  _biometricEnabled = value;
                });
              },
              onSessionTimeoutChanged: (value) {
                setState(() {
                  _sessionTimeout = value;
                });
              },
              onChangeMasterPassword: () {
                Navigator.pushNamed(context, AppRoutes.masterPasswordSetup);
              },
            ),

            SizedBox(height: 6.w),

            // Encryption Settings
            EncryptionSettingsWidget(
              algorithm: _encryptionAlgorithm,
              pbkdf2Iterations: _pbkdf2Iterations,
              onAlgorithmChanged: (value) {
                setState(() {
                  _encryptionAlgorithm = value!;
                });
              },
              onIterationsChanged: (value) {
                setState(() {
                  _pbkdf2Iterations = value;
                });
              },
            ),

            SizedBox(height: 6.w),

            // Auto-Lock Settings
            AutoLockSettingsWidget(
              interval: _autoLockInterval,
              screenCaptureProtection: _screenCaptureProtection,
              secureKeyboard: _secureKeyboard,
              onIntervalChanged: (value) {
                setState(() {
                  _autoLockInterval = value;
                });
              },
              onScreenCaptureChanged: (value) {
                setState(() {
                  _screenCaptureProtection = value;
                });
              },
              onSecureKeyboardChanged: (value) {
                setState(() {
                  _secureKeyboard = value;
                });
              },
            ),

            SizedBox(height: 6.w),

            // Privacy Settings
            PrivacySettingsWidget(
              dataCollection: _dataCollection,
              crashReporting: _crashReporting,
              onDataCollectionChanged: (value) {
                setState(() {
                  _dataCollection = value;
                });
              },
              onCrashReportingChanged: (value) {
                setState(() {
                  _crashReporting = value;
                });
              },
            ),

            SizedBox(height: 6.w),

            // Security Audit
            SecurityAuditWidget(
              onRunAudit: () {
                _runSecurityAudit();
              },
            ),

            SizedBox(height: 6.w),

            // Emergency Access
            EmergencyAccessWidget(
              onConfigureEmergencyAccess: () {
                _configureEmergencyAccess();
              },
            ),

            SizedBox(height: 6.w),

            // Export Security Settings
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export & Backup',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      'Backup your security configuration for device migration',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 4.w),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _exportSecuritySettings();
                        },
                        child: const Text('Export Settings'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8.w),
          ],
        ),
      ),
    );
  }

  void _showSecurityHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Settings Help'),
        content: const Text(
          'Configure your vault\'s security settings to protect your sensitive data. Enable biometric authentication, adjust session timeouts, and customize encryption parameters based on your security needs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _runSecurityAudit() {
    // TODO: Implement comprehensive security audit
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Running security audit...'),
      ),
    );
  }

  void _configureEmergencyAccess() {
    // TODO: Navigate to emergency access configuration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency access configuration coming soon'),
      ),
    );
  }

  void _exportSecuritySettings() {
    // TODO: Implement settings export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting security settings...'),
      ),
    );
  }
}