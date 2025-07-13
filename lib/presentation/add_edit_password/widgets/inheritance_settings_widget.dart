import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InheritanceSettingsWidget extends StatelessWidget {
  final bool includeInDigitalWill;
  final List<String> selectedFamilyMembers;
  final List<Map<String, dynamic>> familyMembers;
  final Function(bool) onIncludeInDigitalWillChanged;
  final Function(List<String>) onFamilyMemberSelectionChanged;

  const InheritanceSettingsWidget({
    Key? key,
    required this.includeInDigitalWill,
    required this.selectedFamilyMembers,
    required this.familyMembers,
    required this.onIncludeInDigitalWillChanged,
    required this.onFamilyMemberSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'family_restroom',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Inheritance Settings',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Digital Will Toggle
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Include in Digital Will',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Allow nominated family members to access this password after your passing',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: includeInDigitalWill,
                      onChanged: onIncludeInDigitalWillChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Family Member Selection (shown when digital will is enabled)
          if (includeInDigitalWill) ...[
            SizedBox(height: 4.h),
            Text(
              'Select Family Members',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Choose which family members will have access to this password',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 3.h),
            ...familyMembers.map((member) {
              final isSelected = selectedFamilyMembers.contains(member['name']);
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.05)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (bool? value) {
                    List<String> updatedMembers =
                        List.from(selectedFamilyMembers);
                    if (value == true) {
                      updatedMembers.add(member['name']);
                    } else {
                      updatedMembers.remove(member['name']);
                    }
                    onFamilyMemberSelectionChanged(updatedMembers);
                  },
                  title: Text(
                    member['name'],
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['relationship'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        member['email'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  secondary: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: member['avatar'],
                        width: 12.w,
                        height: 12.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                ),
              );
            }).toList(),
            if (selectedFamilyMembers.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        '${selectedFamilyMembers.length} family member(s) selected. They will receive access after inheritance activation.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          // Setup Digital Will Button (shown when not enabled)
          if (!includeInDigitalWill) ...[
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/digital-will-setup');
                },
                icon: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Setup Digital Will'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
