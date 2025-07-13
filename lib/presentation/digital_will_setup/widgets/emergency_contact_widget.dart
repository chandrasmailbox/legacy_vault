import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactWidget extends StatelessWidget {
  final List<Map<String, dynamic>> familyMembers;
  final String? selectedContactId;
  final Function(String?) onContactSelected;
  final VoidCallback onTestNotification;

  const EmergencyContactWidget({
    Key? key,
    required this.familyMembers,
    required this.selectedContactId,
    required this.onContactSelected,
    required this.onTestNotification,
  }) : super(key: key);

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
                iconName: 'priority_high',
                color: AppTheme.warningLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Emergency Contact',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          Text(
            'Select one family member to receive immediate notifications when inheritance process begins.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 3.h),

          // Emergency contact selection
          familyMembers.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.errorContainer
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.errorLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: AppTheme.errorLight,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'No family members available',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Add family members first to select an emergency contact',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: familyMembers.map((member) {
                    final isSelected = selectedContactId == member["id"];

                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: InkWell(
                        onTap: () => onContactSelected(member["id"] as String),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.warningLight.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.warningLight
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
                                        ? AppTheme.warningLight
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? AppTheme.warningLight
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

                              // Member info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member["name"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? AppTheme.warningLight
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${member["relationship"]} • ${member["email"]}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Emergency badge
                              if (isSelected)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.warningLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'EMERGENCY',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

          // Test notification button
          if (selectedContactId != null)
            Column(
              children: [
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onTestNotification,
                    style:
                        AppTheme.lightTheme.outlinedButtonTheme.style?.copyWith(
                      side: WidgetStateProperty.all(
                        BorderSide(
                          color: AppTheme.warningLight,
                          width: 1.5,
                        ),
                      ),
                      foregroundColor:
                          WidgetStateProperty.all(AppTheme.warningLight),
                    ),
                    icon: CustomIconWidget(
                      iconName: 'send',
                      color: AppTheme.warningLight,
                      size: 20,
                    ),
                    label: Text('Test Notification'),
                  ),
                ),
                SizedBox(height: 2.h),
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
                            'Test Notification',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Send a sample inheritance alert to verify that your emergency contact can receive notifications properly.',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
