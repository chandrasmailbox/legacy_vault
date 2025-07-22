import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthenticationSettingsWidget extends StatelessWidget {
  final bool biometricEnabled;
  final int sessionTimeout;
  final ValueChanged<bool> onBiometricChanged;
  final ValueChanged<int> onSessionTimeoutChanged;
  final VoidCallback onChangeMasterPassword;

  const AuthenticationSettingsWidget({
    Key? key,
    required this.biometricEnabled,
    required this.sessionTimeout,
    required this.onBiometricChanged,
    required this.onSessionTimeoutChanged,
    required this.onChangeMasterPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_person,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Authentication',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: 4.w),

            // Master Password
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.key,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: const Text('Master Password'),
              subtitle: const Text('Change your vault master password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: onChangeMasterPassword,
            ),

            Divider(height: 4.w, thickness: 0.5),

            // Biometric Authentication
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.fingerprint,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              title: const Text('Biometric Authentication'),
              subtitle: Text(
                biometricEnabled
                    ? 'Fingerprint and Face ID enabled'
                    : 'Use fingerprint or Face ID to unlock',
              ),
              trailing: Switch(
                value: biometricEnabled,
                onChanged: onBiometricChanged,
              ),
            ),

            Divider(height: 4.w, thickness: 0.5),

            // Session Timeout
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.timer,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: const Text('Session Timeout'),
              subtitle:
                  Text('Auto-lock after $sessionTimeout minutes of inactivity'),
              trailing: DropdownButton<int>(
                value: sessionTimeout,
                underline: const SizedBox(),
                items: [1, 5, 15, 30, 60].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('${value}min'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    onSessionTimeoutChanged(newValue);
                  }
                },
              ),
            ),

            SizedBox(height: 2.w),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(77),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Your vault will automatically lock after the specified time to protect your data',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}