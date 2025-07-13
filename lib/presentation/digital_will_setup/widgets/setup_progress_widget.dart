import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SetupProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SetupProgressWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step indicators
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    // Step circle
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted || isCurrent
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        border: Border.all(
                          color: isCompleted || isCurrent
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: isCurrent
                                      ? Colors.white
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    // Progress line (except for last step)
                    if (index < totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),

          SizedBox(height: 2.h),

          // Step labels
          Row(
            children: [
              Expanded(
                child: Text(
                  'Introduction',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: currentStep >= 0
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 0 ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Check-ins',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: currentStep >= 1
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 1 ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Family',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: currentStep >= 2
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 2 ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Complete',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: currentStep >= 3
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 3 ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress percentage
          LinearProgressIndicator(
            value: (currentStep + 1) / totalSteps,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Step ${currentStep + 1} of $totalSteps',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
