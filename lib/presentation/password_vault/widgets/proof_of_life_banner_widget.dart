import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProofOfLifeBannerWidget extends StatelessWidget {
  final DateTime nextCheckIn;
  final VoidCallback onCheckIn;

  const ProofOfLifeBannerWidget({
    super.key,
    required this.nextCheckIn,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntilCheckIn = nextCheckIn.difference(DateTime.now()).inDays;
    final isUrgent = daysUntilCheckIn <= 3;

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color:
            isUrgent
                ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isUrgent
                  ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
                  : AppTheme.lightTheme.colorScheme.primary.withValues(
                    alpha: 0.3,
                  ),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color:
                  isUrgent
                      ? AppTheme.lightTheme.colorScheme.error.withValues(
                        alpha: 0.2,
                      )
                      : AppTheme.lightTheme.colorScheme.primary.withValues(
                        alpha: 0.2,
                      ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: isUrgent ? 'warning' : 'favorite',
                color:
                    isUrgent
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUrgent ? 'Check-in Required Soon' : 'Next Proof of Life',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        isUrgent
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  daysUntilCheckIn > 0
                      ? '$daysUntilCheckIn days remaining'
                      : daysUntilCheckIn == 0
                      ? 'Due today'
                      : 'Overdue by ${-daysUntilCheckIn} days',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          ElevatedButton(
            onPressed: onCheckIn,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isUrgent
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Check In',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
