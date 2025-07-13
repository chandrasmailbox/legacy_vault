import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InheritanceDelayWidget extends StatelessWidget {
  final int delayDays;
  final Function(int) onDelayChanged;

  const InheritanceDelayWidget({
    Key? key,
    required this.delayDays,
    required this.onDelayChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> _delayOptions = const [
    {"days": 1, "label": "24 Hours", "description": "Immediate inheritance"},
    {"days": 3, "label": "3 Days", "description": "Short delay period"},
    {"days": 7, "label": "1 Week", "description": "Standard delay period"},
    {"days": 14, "label": "2 Weeks", "description": "Extended delay period"},
    {"days": 30, "label": "1 Month", "description": "Maximum delay period"},
  ];

  String _getDelayDescription(int days) {
    if (days == 1) {
      return "Inheritance will begin 24 hours after missed check-in";
    } else if (days < 7) {
      return "Inheritance will begin $days days after missed check-in";
    } else if (days == 7) {
      return "Inheritance will begin 1 week after missed check-in";
    } else if (days == 14) {
      return "Inheritance will begin 2 weeks after missed check-in";
    } else {
      return "Inheritance will begin 1 month after missed check-in";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'timer',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Inheritance Delay Period',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          Text(
            'Set how long to wait after missed check-ins before starting the inheritance process.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 3.h),

          // Delay options
          Column(
            children: _delayOptions.map((option) {
              final isSelected = delayDays == option["days"];

              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: InkWell(
                  onTap: () => onDelayChanged(option["days"] as int),
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

                        SizedBox(width: 4.w),

                        // Label and description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option["label"] as String,
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                option["description"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
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

          SizedBox(height: 2.h),

          // Selected delay explanation
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Dead Man\'s Switch',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  _getDelayDescription(delayDays),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
