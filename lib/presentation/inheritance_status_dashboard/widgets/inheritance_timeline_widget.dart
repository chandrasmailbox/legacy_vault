import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class InheritanceTimelineWidget extends StatelessWidget {
  final String currentStatus;
  final Duration timeToNextCheckIn;

  const InheritanceTimelineWidget({
    super.key,
    required this.currentStatus,
    required this.timeToNextCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'timeline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Inheritance Timeline',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Column(
            children: [
              _buildTimelineStep(
                'Check-in Required',
                _getCheckInDescription(),
                _isStepActive(1),
                _isStepCompleted(1),
                Icons.schedule,
              ),
              _buildTimelineStep(
                'First Warning Period',
                'Grace period begins, family members notified',
                _isStepActive(2),
                _isStepCompleted(2),
                Icons.warning,
              ),
              _buildTimelineStep(
                'Final Warning Period',
                'Additional notifications sent to all contacts',
                _isStepActive(3),
                _isStepCompleted(3),
                Icons.error_outline,
              ),
              _buildTimelineStep(
                'Inheritance Activated',
                'Digital assets transferred to beneficiaries',
                _isStepActive(4),
                _isStepCompleted(4),
                Icons.share,
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCheckInDescription() {
    if (timeToNextCheckIn.inSeconds <= 0) {
      return 'Check-in is overdue - immediate action required';
    } else if (timeToNextCheckIn.inDays <= 1) {
      return 'Check-in required within 24 hours';
    } else {
      final days = timeToNextCheckIn.inDays;
      return 'Next check-in in $days day${days > 1 ? 's' : ''}';
    }
  }

  bool _isStepActive(int step) {
    switch (step) {
      case 1:
        return currentStatus == 'active' || currentStatus == 'warning';
      case 2:
        return currentStatus == 'warning';
      case 3:
        return currentStatus == 'triggered' && timeToNextCheckIn.inDays >= -3;
      case 4:
        return currentStatus == 'triggered' && timeToNextCheckIn.inDays < -3;
      default:
        return false;
    }
  }

  bool _isStepCompleted(int step) {
    switch (currentStatus) {
      case 'active':
        return false;
      case 'warning':
        return step < 2;
      case 'triggered':
        return step < 3;
      default:
        return false;
    }
  }

  Widget _buildTimelineStep(
    String title,
    String description,
    bool isActive,
    bool isCompleted,
    IconData icon, {
    bool isLast = false,
  }) {
    Color stepColor;
    if (isCompleted) {
      stepColor = Colors.green;
    } else if (isActive) {
      stepColor = AppTheme.lightTheme.colorScheme.primary;
    } else {
      stepColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant.withAlpha(
        128,
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: stepColor.withAlpha(26),
                  shape: BoxShape.circle,
                  border: Border.all(color: stepColor, width: 2),
                ),
                child: Icon(
                  isCompleted ? Icons.check : icon,
                  color: stepColor,
                  size: 20,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: stepColor.withAlpha(64),
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                  ),
                ),
            ],
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: stepColor,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isActive && !isCompleted) ...[
                    SizedBox(height: 1.h),
                    _buildEstimatedTime(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedTime() {
    String timeText;
    if (timeToNextCheckIn.inSeconds <= 0) {
      timeText = 'Now';
    } else if (timeToNextCheckIn.inHours < 24) {
      timeText =
          'In ${timeToNextCheckIn.inHours}h ${timeToNextCheckIn.inMinutes % 60}m';
    } else {
      timeText =
          'In ${timeToNextCheckIn.inDays} day${timeToNextCheckIn.inDays > 1 ? 's' : ''}';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'schedule',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            timeText,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
