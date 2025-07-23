import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> options;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChipsWidget({
    Key? key,
    required this.options,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            options.map((option) {
              final isSelected = option == selectedFilter;
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onFilterChanged(option);
                    }
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  selectedColor: AppTheme.lightTheme.primaryColor.withValues(
                    alpha: 0.1,
                  ),
                  checkmarkColor: AppTheme.lightTheme.primaryColor,
                  labelStyle: AppTheme.lightTheme.textTheme.labelMedium
                      ?.copyWith(
                        color:
                            isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme
                                    .lightTheme
                                    .colorScheme
                                    .onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                  side: BorderSide(
                    color:
                        isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
