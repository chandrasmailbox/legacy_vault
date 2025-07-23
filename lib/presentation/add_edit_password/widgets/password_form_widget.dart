import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PasswordFormWidget extends StatelessWidget {
  final TextEditingController serviceNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController websiteController;
  final TextEditingController notesController;
  final bool isPasswordVisible;
  final int passwordStrength;
  final String selectedCategory;
  final List<String> categories;
  final List<String> serviceNameSuggestions;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onGeneratePassword;
  final Function(String) onCategoryChanged;

  const PasswordFormWidget({
    Key? key,
    required this.serviceNameController,
    required this.usernameController,
    required this.passwordController,
    required this.websiteController,
    required this.notesController,
    required this.isPasswordVisible,
    required this.passwordStrength,
    required this.selectedCategory,
    required this.categories,
    required this.serviceNameSuggestions,
    required this.onPasswordVisibilityToggle,
    required this.onGeneratePassword,
    required this.onCategoryChanged,
  }) : super(key: key);

  Color _getPasswordStrengthColor() {
    if (passwordStrength <= 2) return AppTheme.lightTheme.colorScheme.error;
    if (passwordStrength <= 4) return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.lightTheme.colorScheme.primary;
  }

  String _getPasswordStrengthText() {
    if (passwordStrength <= 2) return 'Weak';
    if (passwordStrength <= 4) return 'Medium';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Service Name Field with Autocomplete
        Text(
          'Service Name',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return serviceNameSuggestions.where((String option) {
              return option.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
            });
          },
          onSelected: (String selection) {
            serviceNameController.text = selection;
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            controller.text = serviceNameController.text;
            controller.addListener(() {
              serviceNameController.text = controller.text;
            });

            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'e.g., Gmail, Facebook, Bank of America',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'business',
                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
                    size: 20,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Service name is required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            );
          },
        ),
        SizedBox(height: 4.h),

        // Username/Email Field
        Text(
          'Username/Email',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: 'Enter username or email',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
                size: 20,
              ),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Username/Email is required';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 4.h),

        // Password Field
        Text(
          'Password',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Enter password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
                size: 20,
              ),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: CustomIconWidget(
                    iconName:
                        isPasswordVisible ? 'visibility_off' : 'visibility',
                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
                    size: 20,
                  ),
                  onPressed: onPasswordVisibilityToggle,
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'auto_fix_high',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: onGeneratePassword,
                  tooltip: 'Generate Password',
                ),
              ],
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),

        // Password Strength Indicator
        if (passwordController.text.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: passwordStrength / 6,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getPasswordStrengthColor(),
                  ),
                  minHeight: 1.h,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                _getPasswordStrengthText(),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _getPasswordStrengthColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 4.h),

        // Website URL Field
        Text(
          'Website URL (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: websiteController,
          decoration: InputDecoration(
            hintText: 'https://example.com',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'language',
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
                size: 20,
              ),
            ),
          ),
          keyboardType: TextInputType.url,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final uri = Uri.tryParse(value);
              if (uri == null || !uri.hasAbsolutePath) {
                return 'Please enter a valid URL';
              }
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 4.h),

        // Category Selection
        Text(
          'Category',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children:
              categories.map((category) {
                final isSelected = selectedCategory == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onCategoryChanged(category);
                    }
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  selectedColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                  labelStyle: AppTheme.lightTheme.textTheme.bodyMedium
                      ?.copyWith(
                        color:
                            isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                  side: BorderSide(
                    color:
                        isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                );
              }).toList(),
        ),
        SizedBox(height: 4.h),

        // Notes Field
        Text(
          'Notes (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: notesController,
          decoration: InputDecoration(
            hintText: 'Security questions, recovery codes, etc.',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'notes',
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
                size: 20,
              ),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }
}
