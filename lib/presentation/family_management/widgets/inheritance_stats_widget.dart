import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InheritanceStatsWidget extends StatelessWidget {
  final int totalMembers;
  final int activeInheritors;
  final int totalInheritedItems;
  final int verificationNeeded;

  const InheritanceStatsWidget({
    Key? key,
    required this.totalMembers,
    required this.activeInheritors,
    required this.totalInheritedItems,
    required this.verificationNeeded,
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
                CustomIconWidget(
                  iconName: 'family_restroom',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Family Overview',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: 'people',
                    title: 'Total Members',
                    value: totalMembers.toString(),
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildStatCard(
                    icon: 'security',
                    title: 'Active Inheritors',
                    value: activeInheritors.toString(),
                    color: AppTheme.successLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: 'lock',
                    title: 'Inherited Items',
                    value: totalInheritedItems.toString(),
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildStatCard(
                    icon: 'warning',
                    title: 'Need Verification',
                    value: verificationNeeded.toString(),
                    color: verificationNeeded > 0
                        ? AppTheme.warningLight
                        : AppTheme.successLight,
                  ),
                ),
              ],
            ),
            if (verificationNeeded > 0) ...[
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.warningLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.warningLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        '$verificationNeeded family member${verificationNeeded > 1 ? 's' : ''} need${verificationNeeded == 1 ? 's' : ''} contact verification',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
              Spacer(),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
