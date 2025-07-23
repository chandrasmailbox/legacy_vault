import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EncryptionSettingsWidget extends StatelessWidget {
  final String algorithm;
  final int pbkdf2Iterations;
  final ValueChanged<String?> onAlgorithmChanged;
  final ValueChanged<int> onIterationsChanged;

  const EncryptionSettingsWidget({
    Key? key,
    required this.algorithm,
    required this.pbkdf2Iterations,
    required this.onAlgorithmChanged,
    required this.onIterationsChanged,
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
                  Icons.enhanced_encryption,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Encryption Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.w),

            // Current Algorithm
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.security,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: const Text('Encryption Algorithm'),
              subtitle: Text('Current: $algorithm - Military grade encryption'),
              trailing: DropdownButton<String>(
                value: algorithm,
                underline: const SizedBox(),
                items:
                    ['AES-256', 'AES-128'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: onAlgorithmChanged,
              ),
            ),

            Divider(height: 4.w, thickness: 0.5),

            // PBKDF2 Iterations
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.loop,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              title: const Text('Key Derivation'),
              subtitle: Text(
                'PBKDF2 iterations: ${_formatIterations(pbkdf2Iterations)}',
              ),
              trailing: PopupMenuButton<int>(
                child: const Icon(Icons.more_vert),
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 50000,
                        child: Text('50,000 (Fast)'),
                      ),
                      const PopupMenuItem(
                        value: 100000,
                        child: Text('100,000 (Recommended)'),
                      ),
                      const PopupMenuItem(
                        value: 200000,
                        child: Text('200,000 (Secure)'),
                      ),
                      const PopupMenuItem(
                        value: 500000,
                        child: Text('500,000 (Maximum)'),
                      ),
                    ],
                onSelected: onIterationsChanged,
              ),
            ),

            SizedBox(height: 4.w),

            // Security Information Panel
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
                        Icons.verified_user,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Encryption Details',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  _buildDetailRow(context, 'Algorithm', algorithm),
                  _buildDetailRow(context, 'Key Size', '256-bit'),
                  _buildDetailRow(context, 'Block Mode', 'CBC'),
                  _buildDetailRow(
                    context,
                    'Iterations',
                    _formatIterations(pbkdf2Iterations),
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    'Higher iteration counts provide better security but may slow down vault operations. The recommended setting balances security and performance.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
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

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  String _formatIterations(int iterations) {
    if (iterations >= 1000000) {
      return '${(iterations / 1000000).toStringAsFixed(1)}M';
    } else if (iterations >= 1000) {
      return '${(iterations / 1000).toStringAsFixed(0)}K';
    }
    return iterations.toString();
  }
}
