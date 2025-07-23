import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class BeneficiaryOverviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> beneficiaries;
  final VoidCallback onViewAll;
  final Function(int) onModifyPermissions;

  const BeneficiaryOverviewWidget({
    super.key,
    required this.beneficiaries,
    required this.onViewAll,
    required this.onModifyPermissions,
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
                iconName: 'people',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Beneficiaries',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(onPressed: onViewAll, child: const Text('View All')),
            ],
          ),
          SizedBox(height: 2.h),
          if (beneficiaries.isEmpty)
            _buildEmptyState()
          else
            Column(
              children:
                  beneficiaries.take(3).map((beneficiary) {
                    return _buildBeneficiaryCard(context, beneficiary);
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'person_add',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withAlpha(
              128,
            ),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No beneficiaries added yet',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          ElevatedButton(
            onPressed: onViewAll,
            child: const Text('Add Your First Beneficiary'),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryCard(
    BuildContext context,
    Map<String, dynamic> beneficiary,
  ) {
    final isVerified = beneficiary["verificationStatus"] == "Verified";

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha(64),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.w),
                child: CachedNetworkImage(
                  imageUrl: beneficiary["avatar"],
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          beneficiary["name"],
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 2.w),
                        if (isVerified)
                          CustomIconWidget(
                            iconName: 'verified',
                            color: Colors.green,
                            size: 16,
                          )
                        else
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: Colors.orange,
                            size: 16,
                          ),
                      ],
                    ),
                    Text(
                      beneficiary["relationship"],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onModifyPermissions(beneficiary["id"]),
                icon: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              _buildInfoChip(
                beneficiary["accessLevel"],
                _getAccessLevelColor(beneficiary["accessLevel"]),
              ),
              SizedBox(width: 2.w),
              _buildInfoChip(
                '${beneficiary["inheritedItemsCount"]} items',
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Category breakdown
          Row(
            children: [
              Text(
                'Categories: ',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              ...beneficiary["categories"].entries.map<Widget>((entry) {
                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: Text(
                    '${entry.key} (${entry.value})',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getAccessLevelColor(String accessLevel) {
    switch (accessLevel) {
      case 'Full Access':
        return Colors.green;
      case 'Limited Access':
        return Colors.orange;
      case 'Emergency Only':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return Colors.grey;
    }
  }
}
