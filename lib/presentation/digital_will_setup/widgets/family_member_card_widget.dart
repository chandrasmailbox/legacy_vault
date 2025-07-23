import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class FamilyMemberCardWidget extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const FamilyMemberCardWidget({
    Key? key,
    required this.member,
    required this.onRemove,
    required this.onEdit,
  }) : super(key: key);

  String _getRelationshipIcon(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'spouse':
      case 'partner':
        return 'favorite';
      case 'son':
      case 'daughter':
      case 'child':
        return 'child_care';
      case 'parent':
      case 'father':
      case 'mother':
        return 'elderly';
      case 'sibling':
      case 'brother':
      case 'sister':
        return 'people';
      default:
        return 'person';
    }
  }

  Color _getRelationshipColor(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'spouse':
      case 'partner':
        return AppTheme.errorLight;
      case 'son':
      case 'daughter':
      case 'child':
        return AppTheme.successLight;
      case 'parent':
      case 'father':
      case 'mother':
        return AppTheme.warningLight;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key(member["id"] as String),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.errorLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Remove',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        'Remove Family Member',
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                      content: Text(
                        'Are you sure you want to remove ${member["name"]} from your digital will?',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.errorLight,
                          ),
                          child: Text('Remove'),
                        ),
                      ],
                    ),
              ) ??
              false;
        },
        onDismissed: (direction) => onRemove(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.2,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow.withValues(
                  alpha: 0.05,
                ),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Avatar with relationship icon
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getRelationshipColor(
                        member["relationship"] as String,
                      ).withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getRelationshipIcon(
                          member["relationship"] as String,
                        ),
                        color: _getRelationshipColor(
                          member["relationship"] as String,
                        ),
                        size: 24,
                      ),
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Name and relationship
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member["name"] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          member["relationship"] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                color: _getRelationshipColor(
                                  member["relationship"] as String,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Edit button
                  IconButton(
                    onPressed: onEdit,
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Contact information
              Column(
                children: [
                  // Email
                  if (member["email"] != null &&
                      (member["email"] as String).isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'email',
                            color:
                                AppTheme
                                    .lightTheme
                                    .colorScheme
                                    .onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              member["email"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Phone
                  if (member["phone"] != null &&
                      (member["phone"] as String).isNotEmpty)
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'phone',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            member["phone"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // Emergency contact badge
              if (member["isEmergencyContact"] == true)
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warningLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.warningLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'priority_high',
                          color: AppTheme.warningLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Emergency Contact',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.warningLight,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
