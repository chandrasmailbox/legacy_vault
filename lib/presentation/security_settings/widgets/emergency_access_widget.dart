import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmergencyAccessWidget extends StatefulWidget {
  final VoidCallback onConfigureEmergencyAccess;

  const EmergencyAccessWidget({
    Key? key,
    required this.onConfigureEmergencyAccess,
  }) : super(key: key);

  @override
  State<EmergencyAccessWidget> createState() => _EmergencyAccessWidgetState();
}

class _EmergencyAccessWidgetState extends State<EmergencyAccessWidget> {
  bool _emergencyAccessEnabled = false;
  int _trustedContacts = 2;
  int _waitingPeriod = 72; // hours

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
                  Icons.emergency_share,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Emergency Access',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.w),
            Text(
              'Configure trusted contacts who can request access to your vault in case of emergency',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 4.w),

            // Emergency Access Status
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color:
                    _emergencyAccessEnabled
                        ? Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withAlpha(26)
                        : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      _emergencyAccessEnabled
                          ? Theme.of(context).colorScheme.primary.withAlpha(77)
                          : Theme.of(context).colorScheme.outline.withAlpha(77),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _emergencyAccessEnabled
                                ? Icons.check_circle
                                : Icons.info_outline,
                            size: 16.sp,
                            color:
                                _emergencyAccessEnabled
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _emergencyAccessEnabled
                                ? 'Configured'
                                : 'Not Configured',
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              color:
                                  _emergencyAccessEnabled
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _emergencyAccessEnabled,
                        onChanged: (value) {
                          setState(() {
                            _emergencyAccessEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_emergencyAccessEnabled) ...[
                    SizedBox(height: 2.w),
                    _buildEmergencyAccessDetails(),
                  ],
                ],
              ),
            ),

            SizedBox(height: 4.w),

            // Configure Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  widget.onConfigureEmergencyAccess();
                  _showEmergencyAccessDialog();
                },
                icon: const Icon(Icons.settings),
                label: Text(
                  _emergencyAccessEnabled
                      ? 'Manage Emergency Contacts'
                      : 'Set Up Emergency Access',
                ),
              ),
            ),

            SizedBox(height: 4.w),

            // Information Panel
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
                        Icons.help_outline,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'How Emergency Access Works',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  _buildInfoStep(
                    context,
                    '1',
                    'Trusted Contact Request',
                    'Your emergency contact initiates an access request',
                  ),
                  _buildInfoStep(
                    context,
                    '2',
                    'Waiting Period',
                    'A $_waitingPeriod-hour waiting period begins for your security',
                  ),
                  _buildInfoStep(
                    context,
                    '3',
                    'Notification & Override',
                    'You receive notifications and can deny the request',
                  ),
                  _buildInfoStep(
                    context,
                    '4',
                    'Vault Access Granted',
                    'If not denied, limited vault access is granted',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyAccessDetails() {
    return Column(
      children: [
        _buildDetailRow('Trusted Contacts', '$_trustedContacts configured'),
        _buildDetailRow('Waiting Period', '$_waitingPeriod hours'),
        _buildDetailRow('Access Level', 'View-only passwords'),
        _buildDetailRow('Notification Method', 'Email & SMS'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStep(
    BuildContext context,
    String step,
    String title,
    String description,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
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

  void _showEmergencyAccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Emergency Access Setup'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Emergency access allows trusted individuals to request access to your vault if you become unable to access it yourself.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Key Features:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Multi-step verification process'),
                  const Text('• Configurable waiting period'),
                  const Text('• Multiple notification methods'),
                  const Text('• Limited access permissions'),
                  const Text('• Full audit trail'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Your vault remains secure with zero-knowledge encryption even during emergency access.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Emergency access setup will be available soon',
                      ),
                    ),
                  );
                },
                child: const Text('Set Up Now'),
              ),
            ],
          ),
    );
  }
}
