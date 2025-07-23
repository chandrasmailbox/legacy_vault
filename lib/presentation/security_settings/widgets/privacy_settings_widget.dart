import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrivacySettingsWidget extends StatelessWidget {
  final bool dataCollection;
  final bool crashReporting;
  final ValueChanged<bool> onDataCollectionChanged;
  final ValueChanged<bool> onCrashReportingChanged;

  const PrivacySettingsWidget({
    Key? key,
    required this.dataCollection,
    required this.crashReporting,
    required this.onDataCollectionChanged,
    required this.onCrashReportingChanged,
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
                  Icons.privacy_tip,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Privacy Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.w),

            // Data Collection
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.analytics,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: const Text('Analytics & Data Collection'),
              subtitle: Text(
                dataCollection
                    ? 'Sharing usage data to improve the app'
                    : 'No usage data is collected or shared',
              ),
              trailing: Switch(
                value: dataCollection,
                onChanged: onDataCollectionChanged,
              ),
            ),

            Divider(height: 4.w, thickness: 0.5),

            // Crash Reporting
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bug_report,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              title: const Text('Crash Reporting'),
              subtitle: Text(
                crashReporting
                    ? 'Send crash reports to help fix issues'
                    : 'Crash reports are not sent',
              ),
              trailing: Switch(
                value: crashReporting,
                onChanged: onCrashReportingChanged,
              ),
            ),

            SizedBox(height: 4.w),

            // Privacy Information
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withAlpha(77),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Privacy Commitment',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  _buildPrivacyPoint(
                    context,
                    'Zero-Knowledge Architecture',
                    'Your vault data is encrypted locally and we cannot access it',
                  ),
                  _buildPrivacyPoint(
                    context,
                    'Minimal Data Collection',
                    'Only anonymous usage statistics are collected when enabled',
                  ),
                  _buildPrivacyPoint(
                    context,
                    'No Third-Party Tracking',
                    'We do not use advertising networks or social media trackers',
                  ),
                  _buildPrivacyPoint(
                    context,
                    'Open Source Security',
                    'Our encryption and security methods are transparent and auditable',
                  ),
                  SizedBox(height: 2.w),
                  InkWell(
                    onTap: () {
                      _showPrivacyPolicy(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 14.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Read Full Privacy Policy',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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

  Widget _buildPrivacyPoint(
    BuildContext context,
    String title,
    String description,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 14.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Privacy Policy'),
            content: const SingleChildScrollView(
              child: Text(
                'Your privacy is our top priority. This app uses zero-knowledge encryption, meaning we cannot access your vault data even if we wanted to.\n\n'
                'When analytics are enabled, we only collect anonymous usage statistics to improve the app experience. No personal information or vault contents are ever transmitted.\n\n'
                'Crash reports help us identify and fix issues quickly, but they never contain your sensitive data.\n\n'
                'For complete details, visit our website or contact support.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Open privacy policy in browser
                  Navigator.pop(context);
                },
                child: const Text('View Full Policy'),
              ),
            ],
          ),
    );
  }
}
