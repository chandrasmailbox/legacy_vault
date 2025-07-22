import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onCheckIn;
  final VoidCallback onModifySchedule;
  final VoidCallback onAddBeneficiary;
  final VoidCallback onEmergencyContact;
  final VoidCallback onTestInheritance;

  const QuickActionsWidget({
    super.key,
    required this.onCheckIn,
    required this.onModifySchedule,
    required this.onAddBeneficiary,
    required this.onEmergencyContact,
    required this.onTestInheritance,
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
                iconName: 'flash_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Quick Actions',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 3.5,
            children: [
              _buildActionButton(
                'Manual Check-in',
                'check',
                Colors.green,
                onCheckIn,
              ),
              _buildActionButton(
                'Modify Schedule',
                'schedule',
                AppTheme.lightTheme.colorScheme.primary,
                onModifySchedule,
              ),
              _buildActionButton(
                'Add Beneficiary',
                'person_add',
                Colors.orange,
                onAddBeneficiary,
              ),
              _buildActionButton(
                'Emergency Contact',
                'emergency',
                AppTheme.lightTheme.colorScheme.error,
                onEmergencyContact,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Test inheritance process button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                  AppTheme.lightTheme.colorScheme.primary.withAlpha(13),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary.withAlpha(64),
              ),
            ),
            child: InkWell(
              onTap: onTestInheritance,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withAlpha(26),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'science',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Test Inheritance Process',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                'Simulate the complete workflow',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withAlpha(179),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String iconName,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withAlpha(64),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
