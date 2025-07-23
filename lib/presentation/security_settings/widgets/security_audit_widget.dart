import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SecurityAuditWidget extends StatefulWidget {
  final VoidCallback onRunAudit;

  const SecurityAuditWidget({Key? key, required this.onRunAudit})
    : super(key: key);

  @override
  State<SecurityAuditWidget> createState() => _SecurityAuditWidgetState();
}

class _SecurityAuditWidgetState extends State<SecurityAuditWidget> {
  DateTime? lastAuditDate;
  bool isRunningAudit = false;
  Map<String, dynamic> auditResults = {
    'weakPasswords': 3,
    'duplicatePasswords': 2,
    'compromisedCredentials': 0,
    'expiredPasswords': 1,
    'totalPasswords': 45,
  };

  @override
  void initState() {
    super.initState();
    lastAuditDate = DateTime.now().subtract(const Duration(days: 7));
  }

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
                  Icons.security_update_good,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Security Audit',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.w),

            // Last Audit Info
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last Security Scan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        lastAuditDate != null
                            ? _formatDate(lastAuditDate!)
                            : 'Never',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (lastAuditDate != null) ...[
                    SizedBox(height: 3.w),
                    _buildAuditResultsGrid(context),
                  ],
                ],
              ),
            ),

            SizedBox(height: 4.w),

            // Run Audit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isRunningAudit ? null : () => _runSecurityAudit(),
                icon:
                    isRunningAudit
                        ? SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                        : const Icon(Icons.search),
                label: Text(
                  isRunningAudit
                      ? 'Running Security Audit...'
                      : 'Run Comprehensive Security Audit',
                ),
              ),
            ),

            SizedBox(height: 2.w),

            // Audit Information
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
                        Icons.info_outline,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'What does the audit check?',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  _buildAuditCheckItem(
                    context,
                    'Password Strength',
                    'Identifies weak passwords that should be strengthened',
                  ),
                  _buildAuditCheckItem(
                    context,
                    'Duplicate Detection',
                    'Finds accounts using identical passwords',
                  ),
                  _buildAuditCheckItem(
                    context,
                    'Breach Database',
                    'Checks against known compromised credentials',
                  ),
                  _buildAuditCheckItem(
                    context,
                    'Password Age',
                    'Identifies old passwords that should be updated',
                  ),
                  _buildAuditCheckItem(
                    context,
                    'Two-Factor Auth',
                    'Recommends accounts that need 2FA enabled',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditResultsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildResultTile(
            context,
            'Weak',
            auditResults['weakPasswords'].toString(),
            auditResults['weakPasswords'] > 0 ? Colors.orange : Colors.green,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildResultTile(
            context,
            'Duplicates',
            auditResults['duplicatePasswords'].toString(),
            auditResults['duplicatePasswords'] > 0
                ? Colors.orange
                : Colors.green,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildResultTile(
            context,
            'Breached',
            auditResults['compromisedCredentials'].toString(),
            auditResults['compromisedCredentials'] > 0
                ? Theme.of(context).colorScheme.error
                : Colors.green,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildResultTile(
            context,
            'Expired',
            auditResults['expiredPasswords'].toString(),
            auditResults['expiredPasswords'] > 0 ? Colors.orange : Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildResultTile(
    BuildContext context,
    String label,
    String count,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAuditCheckItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.w),
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

  void _runSecurityAudit() {
    setState(() {
      isRunningAudit = true;
    });

    widget.onRunAudit();

    // Simulate audit process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isRunningAudit = false;
          lastAuditDate = DateTime.now();
          // Update audit results with new random data for demo
          auditResults = {
            'weakPasswords': 2,
            'duplicatePasswords': 1,
            'compromisedCredentials': 0,
            'expiredPasswords': 0,
            'totalPasswords': 45,
          };
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Security audit completed successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View Report',
              textColor: Colors.white,
              onPressed: () {
                _showAuditReport();
              },
            ),
          ),
        );
      }
    });
  }

  void _showAuditReport() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Security Audit Report'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Audit completed on ${_formatDate(lastAuditDate!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  _buildReportItem(
                    'Weak Passwords',
                    auditResults['weakPasswords'],
                  ),
                  _buildReportItem(
                    'Duplicate Passwords',
                    auditResults['duplicatePasswords'],
                  ),
                  _buildReportItem(
                    'Compromised Credentials',
                    auditResults['compromisedCredentials'],
                  ),
                  _buildReportItem(
                    'Expired Passwords',
                    auditResults['expiredPasswords'],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recommendations:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (auditResults['weakPasswords'] > 0)
                    const Text(
                      '• Strengthen weak passwords using the password generator',
                    ),
                  if (auditResults['duplicatePasswords'] > 0)
                    const Text(
                      '• Update duplicate passwords with unique alternatives',
                    ),
                  if (auditResults['expiredPasswords'] > 0)
                    const Text(
                      '• Refresh expired passwords for better security',
                    ),
                  if (auditResults['weakPasswords'] == 0 &&
                      auditResults['duplicatePasswords'] == 0 &&
                      auditResults['expiredPasswords'] == 0)
                    const Text('✅ All passwords meet security standards!'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildReportItem(String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: count > 0 ? Colors.orange : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
