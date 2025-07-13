import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CheckInIntervalWidget extends StatelessWidget {
  final String selectedInterval;
  final Function(String) onIntervalChanged;

  const CheckInIntervalWidget({
    Key? key,
    required this.selectedInterval,
    required this.onIntervalChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> _intervals = const [
    {
      "value": "weekly",
      "label": "Weekly",
      "description": "Check-in every 7 days",
      "icon": "calendar_view_week",
    },
    {
      "value": "bi-weekly",
      "label": "Bi-weekly",
      "description": "Check-in every 14 days",
      "icon": "calendar_view_month",
    },
    {
      "value": "monthly",
      "label": "Monthly",
      "description": "Check-in every 30 days",
      "icon": "calendar_month",
    },
    {
      "value": "quarterly",
      "label": "Quarterly",
      "description": "Check-in every 90 days",
      "icon": "event_note",
    },
  ];

  String _getNextCheckInDate(String interval) {
    final now = DateTime.now();
    DateTime nextDate;

    switch (interval) {
      case 'weekly':
        nextDate = now.add(const Duration(days: 7));
        break;
      case 'bi-weekly':
        nextDate = now.add(const Duration(days: 14));
        break;
      case 'monthly':
        nextDate = now.add(const Duration(days: 30));
        break;
      case 'quarterly':
        nextDate = now.add(const Duration(days: 90));
        break;
      default:
        nextDate = now.add(const Duration(days: 30));
    }

    return '${nextDate.month}/${nextDate.day}/${nextDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interval selection
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Check-in Frequency',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 2.h),

              // Interval options
              Column(
                children: _intervals.map((interval) {
                  final isSelected = selectedInterval == interval["value"];

                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: InkWell(
                      onTap: () =>
                          onIntervalChanged(interval["value"] as String),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Radio button
                            Container(
                              width: 5.w,
                              height: 5.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.outline,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 2.w,
                                        height: 2.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),

                            SizedBox(width: 3.w),

                            // Icon
                            CustomIconWidget(
                              iconName: interval["icon"] as String,
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),

                            SizedBox(width: 3.w),

                            // Label and description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    interval["label"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    interval["description"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Timeline preview
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Next Check-in Timeline',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Next Check-in',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          _getNextCheckInDate(selectedInterval),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
