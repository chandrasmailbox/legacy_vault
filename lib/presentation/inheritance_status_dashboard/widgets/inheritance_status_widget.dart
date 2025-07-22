import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InheritanceStatusWidget extends StatelessWidget {
  final String status;
  final Duration timeToNextCheckIn;

  const InheritanceStatusWidget({
    super.key,
    required this.status,
    required this.timeToNextCheckIn,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'triggered':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (status) {
      case 'active':
        return 'ACTIVE';
      case 'warning':
        return 'WARNING';
      case 'triggered':
        return 'TRIGGERED';
      default:
        return 'UNKNOWN';
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'active':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'triggered':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _formatTimeRemaining() {
    if (timeToNextCheckIn.inSeconds <= 0) {
      return 'OVERDUE';
    }

    final days = timeToNextCheckIn.inDays;
    final hours = timeToNextCheckIn.inHours % 24;
    final minutes = timeToNextCheckIn.inMinutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getStatusColor().withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 32,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inheritance Status',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _getStatusText(),
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withAlpha(13),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Check-in Required',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        _formatTimeRemaining(),
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightTheme.colorScheme.primary,
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
    );
  }
}
