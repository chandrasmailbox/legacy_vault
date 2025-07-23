import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProofOfLifeWidget extends StatelessWidget {
  final Duration timeToNextCheckIn;
  final VoidCallback onCheckIn;
  final VoidCallback onEmergencyDelay;

  const ProofOfLifeWidget({
    super.key,
    required this.timeToNextCheckIn,
    required this.onCheckIn,
    required this.onEmergencyDelay,
  });

  bool get _isUrgent => timeToNextCheckIn.inDays <= 1;
  bool get _isOverdue => timeToNextCheckIn.inSeconds <= 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _isOverdue
                  ? AppTheme.lightTheme.colorScheme.error
                  : _isUrgent
                  ? Colors.orange
                  : Colors.transparent,
          width: _isOverdue || _isUrgent ? 2 : 0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color:
                    _isOverdue
                        ? AppTheme.lightTheme.colorScheme.error
                        : _isUrgent
                        ? Colors.orange
                        : AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Proof of Life',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isUrgent || _isOverdue) ...[
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _isOverdue
                            ? AppTheme.lightTheme.colorScheme.error
                            : Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _isOverdue ? 'OVERDUE' : 'URGENT',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            _isOverdue
                ? 'Your check-in is overdue. Please confirm you are well to prevent inheritance activation.'
                : _isUrgent
                ? 'Check-in required soon. Please confirm you are well to maintain your digital legacy.'
                : 'Regular check-in helps ensure your digital assets remain secure until needed.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCheckIn,
                  icon: CustomIconWidget(
                    iconName: 'check',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text('Check In Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isOverdue
                            ? AppTheme.lightTheme.colorScheme.error
                            : _isUrgent
                            ? Colors.orange
                            : AppTheme.lightTheme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              OutlinedButton(
                onPressed: onEmergencyDelay,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.5.h,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'access_time',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
          if (_isUrgent || _isOverdue) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: (_isOverdue
                        ? AppTheme.lightTheme.colorScheme.error
                        : Colors.orange)
                    .withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color:
                        _isOverdue
                            ? AppTheme.lightTheme.colorScheme.error
                            : Colors.orange,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _isOverdue
                          ? 'Missing check-ins will trigger your inheritance process'
                          : 'Check-in within 24 hours to prevent inheritance warnings',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            _isOverdue
                                ? AppTheme.lightTheme.colorScheme.error
                                : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
