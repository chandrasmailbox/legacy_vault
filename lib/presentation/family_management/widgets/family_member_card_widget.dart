import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FamilyMemberCardWidget extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onEdit;
  final VoidCallback onTestContact;
  final VoidCallback onRemove;
  final VoidCallback onViewInheritedItems;
  final VoidCallback onSendTestAlert;
  final VoidCallback onModifyAccess;
  final VoidCallback onChangeRelationship;

  const FamilyMemberCardWidget({
    Key? key,
    required this.member,
    required this.onEdit,
    required this.onTestContact,
    required this.onRemove,
    required this.onViewInheritedItems,
    required this.onSendTestAlert,
    required this.onModifyAccess,
    required this.onChangeRelationship,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppTheme.successLight;
      case 'verification_needed':
        return AppTheme.warningLight;
      case 'unreachable':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.check_circle;
      case 'verification_needed':
        return Icons.warning;
      case 'unreachable':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Active';
      case 'verification_needed':
        return 'Verification Needed';
      case 'unreachable':
        return 'Unreachable';
      default:
        return 'Unknown';
    }
  }

  Color _getAccessLevelColor(String accessLevel) {
    switch (accessLevel) {
      case 'Full Access':
        return AppTheme.successLight;
      case 'Limited Access':
        return AppTheme.warningLight;
      case 'Emergency Contact Only':
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                member['name'] as String,
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              _buildContextMenuItem(
                icon: 'visibility',
                title: 'View Inherited Items',
                subtitle: '${member['inheritedItems']} items',
                onTap: () {
                  Navigator.pop(context);
                  onViewInheritedItems();
                },
              ),
              _buildContextMenuItem(
                icon: 'notification_important',
                title: 'Send Test Alert',
                subtitle: 'Test contact method',
                onTap: () {
                  Navigator.pop(context);
                  onSendTestAlert();
                },
              ),
              _buildContextMenuItem(
                icon: 'security',
                title: 'Modify Access',
                subtitle: 'Change inheritance permissions',
                onTap: () {
                  Navigator.pop(context);
                  onModifyAccess();
                },
              ),
              _buildContextMenuItem(
                icon: 'family_restroom',
                title: 'Change Relationship',
                subtitle: 'Update relationship type',
                onTap: () {
                  Navigator.pop(context);
                  onChangeRelationship();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.primaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onLongPress: () => _showContextMenu(context),
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
          key: Key(member['id'].toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.errorLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomIconWidget(
                  iconName: 'edit',
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'contact_phone',
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'delete',
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Choose Action'),
                  content:
                      Text('What would you like to do with ${member['name']}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                        onEdit();
                      },
                      child: Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                        onTestContact();
                      },
                      child: Text('Test Contact'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                        onRemove();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.errorLight,
                      ),
                      child: Text('Remove'),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile and status
                Row(
                  children: [
                    // Profile image
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getStatusColor(member['status'] as String),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: member['profileImage'] != null
                            ? CustomImageWidget(
                                imageUrl: member['profileImage'] as String,
                                width: 15.w,
                                height: 15.w,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                child: CustomIconWidget(
                                  iconName: 'person',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 8.w,
                                ),
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
                            member['name'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            member['relationship'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    // Status indicator
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(member['status'] as String)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: _getStatusIcon(member['status'] as String)
                                .codePoint
                                .toString(),
                            color: _getStatusColor(member['status'] as String),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _getStatusText(member['status'] as String),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color:
                                  _getStatusColor(member['status'] as String),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Contact information
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'email',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              member['email'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'phone',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              member['phone'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Access level and inherited items
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: _getAccessLevelColor(
                                  member['accessLevel'] as String)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getAccessLevelColor(
                                    member['accessLevel'] as String)
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Access Level',
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              member['accessLevel'] as String,
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: _getAccessLevelColor(
                                    member['accessLevel'] as String),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.dividerColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inherited Items',
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '${member['inheritedItems']} items',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Last contact and verification status
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Last contact: ${member['lastContact']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    Spacer(),
                    if (member['contactVerified'] as bool)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'verified',
                              color: AppTheme.successLight,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Verified',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.successLight,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.warningLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'warning',
                              color: AppTheme.warningLight,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Unverified',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.warningLight,
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
        ),
      ),
    );
  }
}
