import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PasswordCardWidget extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCopyPassword;
  final VoidCallback onCopyUsername;

  const PasswordCardWidget({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onCopyPassword,
    required this.onCopyUsername,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry["id"].toString()),
      background: _buildSwipeBackground(isLeft: true),
      secondaryBackground: _buildSwipeBackground(isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right - quick actions
          _showQuickActions(context);
        } else {
          // Swipe left - delete
          onDelete();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showQuickActions(context);
          return false;
        }
        return true;
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 2.h),
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Service icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: entry["icon"] as String,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Service details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry["serviceName"] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildInheritanceIndicator(),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        entry["username"] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                              color:
                                  AppTheme
                                      .lightTheme
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'update',
                            color:
                                AppTheme
                                    .lightTheme
                                    .colorScheme
                                    .onSurfaceVariant,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Updated ${entry["lastUpdated"]}',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          const Spacer(),
                          if (entry["isSecure"] == true)
                            CustomIconWidget(
                              iconName: 'security',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                // More options
                IconButton(
                  onPressed: () => _showContextMenu(context),
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInheritanceIndicator() {
    Color indicatorColor;
    String status = entry["inheritanceStatus"] as String;

    switch (status) {
      case 'inherited':
        indicatorColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'restricted':
        indicatorColor = Colors.orange;
        break;
      case 'excluded':
        indicatorColor = AppTheme.lightTheme.colorScheme.error;
        break;
      default:
        indicatorColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      width: 3.w,
      height: 3.w,
      decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color:
            isLeft
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.error,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'content_copy' : 'delete',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Copy' : 'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      Text(
                        'Quick Actions',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildQuickActionButton(
                            context,
                            icon: 'content_copy',
                            label: 'Copy Password',
                            onTap: () {
                              Navigator.pop(context);
                              onCopyPassword();
                            },
                          ),
                          _buildQuickActionButton(
                            context,
                            icon: 'edit',
                            label: 'Edit',
                            onTap: () {
                              Navigator.pop(context);
                              onEdit();
                            },
                          ),
                          _buildQuickActionButton(
                            context,
                            icon: 'share',
                            label: 'Share',
                            onTap: () {
                              Navigator.pop(context);
                              // Handle share action
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(label, style: AppTheme.lightTheme.textTheme.bodySmall),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'visibility',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  title: const Text('View Details'),
                  onTap: () {
                    Navigator.pop(context);
                    onTap();
                  },
                ),

                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'content_copy',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  title: const Text('Copy Password'),
                  onTap: () {
                    Navigator.pop(context);
                    onCopyPassword();
                  },
                ),

                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  title: const Text('Copy Username'),
                  onTap: () {
                    Navigator.pop(context);
                    onCopyUsername();
                  },
                ),

                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  title: const Text('Generate New Password'),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle generate new password
                  },
                ),

                const Divider(),

                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                  title: Text(
                    'Delete',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
    );
  }
}
