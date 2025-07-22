import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class AutoLockSettingsWidget extends StatelessWidget {
  final int interval;
  final bool screenCaptureProtection;
  final bool secureKeyboard;
  final ValueChanged<int> onIntervalChanged;
  final ValueChanged<bool> onScreenCaptureChanged;
  final ValueChanged<bool> onSecureKeyboardChanged;

  const AutoLockSettingsWidget({
    Key? key,
    required this.interval,
    required this.screenCaptureProtection,
    required this.secureKeyboard,
    required this.onIntervalChanged,
    required this.onScreenCaptureChanged,
    required this.onSecureKeyboardChanged,
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
                  Icons.lock_clock,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Auto-Lock & Protection',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: 4.w),

            // Auto-Lock Interval
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.schedule,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: const Text('Auto-Lock Timer'),
              subtitle: Text(_getIntervalDescription()),
              trailing: DropdownButton<int>(
                value: interval,
                underline: const SizedBox(),
                items: [0, 1, 2, 5, 10, 30].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value == 0 ? 'Immediate' : '${value}min'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    onIntervalChanged(newValue);
                  }
                },
              ),
            ),

            Divider(height: 4.w, thickness: 0.5),

            // Screen Capture Protection
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.screenshot_monitor,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: const Text('Screen Capture Protection'),
              subtitle: Text(
                screenCaptureProtection
                    ? 'Screenshots and screen recording blocked'
                    : 'Allow screenshots and screen recording',
              ),
              trailing: Switch(
                value: screenCaptureProtection,
                onChanged: onScreenCaptureChanged,
              ),
            ),

            Divider(height: 4.w, thickness: 0.5),

            // Secure Keyboard Detection
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.keyboard_alt,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              title: const Text('Secure Keyboard Detection'),
              subtitle: Text(
                secureKeyboard
                    ? 'Warn when third-party keyboards detected'
                    : 'Allow third-party keyboards',
              ),
              trailing: Switch(
                value: secureKeyboard,
                onChanged: onSecureKeyboardChanged,
              ),
            ),

            SizedBox(height: 4.w),

            // Security Implications Info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(77),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Security Implications',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  _buildImplicationItem(
                    context,
                    'Auto-Lock',
                    _getAutoLockImplication(),
                    _getAutoLockSeverity(),
                  ),
                  _buildImplicationItem(
                    context,
                    'Screen Capture',
                    screenCaptureProtection
                        ? 'High security - prevents data leakage'
                        : 'Medium risk - sensitive data may be captured',
                    screenCaptureProtection ? 'secure' : 'warning',
                  ),
                  _buildImplicationItem(
                    context,
                    'Keyboard Security',
                    secureKeyboard
                        ? 'Enhanced protection against keyloggers'
                        : 'Standard protection - monitor for suspicious keyboards',
                    secureKeyboard ? 'secure' : 'info',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImplicationItem(
      BuildContext context, String title, String description, String severity) {
    Color severityColor;
    IconData severityIcon;

    switch (severity) {
      case 'secure':
        severityColor = Theme.of(context).colorScheme.primary;
        severityIcon = Icons.check_circle;
        break;
      case 'warning':
        severityColor = Colors.orange;
        severityIcon = Icons.warning;
        break;
      case 'error':
        severityColor = Theme.of(context).colorScheme.error;
        severityIcon = Icons.error;
        break;
      default:
        severityColor = Theme.of(context).colorScheme.primary;
        severityIcon = Icons.info;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            severityIcon,
            size: 14.sp,
            color: severityColor,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: severityColor,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIntervalDescription() {
    if (interval == 0) {
      return 'Lock immediately when app is minimized';
    } else if (interval == 1) {
      return 'Lock after 1 minute of inactivity';
    } else {
      return 'Lock after $interval minutes of inactivity';
    }
  }

  String _getAutoLockImplication() {
    if (interval == 0) {
      return 'Maximum security - immediate protection';
    } else if (interval <= 5) {
      return 'High security - quick automatic locking';
    } else if (interval <= 15) {
      return 'Moderate security - balanced convenience';
    } else {
      return 'Lower security - extended exposure window';
    }
  }

  String _getAutoLockSeverity() {
    if (interval == 0) {
      return 'secure';
    } else if (interval <= 5) {
      return 'secure';
    } else if (interval <= 15) {
      return 'info';
    } else {
      return 'warning';
    }
  }
}
