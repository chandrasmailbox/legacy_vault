import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordStrengthWidget extends StatelessWidget {
  final double strength;
  final String strengthText;
  final Color strengthColor;

  const PasswordStrengthWidget({
    Key? key,
    required this.strength,
    required this.strengthText,
    required this.strengthColor,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password Strength',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  strengthText,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: strengthColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: 3.w),
            Container(
              height: 2.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withAlpha(77),
                borderRadius: BorderRadius.circular(1.w),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2.w,
                      decoration: BoxDecoration(
                        color:
                            strength > 0 ? strengthColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: strength,
                        child: Container(
                          decoration: BoxDecoration(
                            color: strengthColor,
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.w),
            Row(
              children: [
                Icon(
                  _getStrengthIcon(),
                  size: 16.sp,
                  color: strengthColor,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getStrengthDescription(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: strengthColor,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStrengthIcon() {
    if (strength < 0.3) {
      return Icons.error_outline;
    } else if (strength < 0.5) {
      return Icons.warning_outlined;
    } else if (strength < 0.7) {
      return Icons.info_outline;
    } else if (strength < 0.9) {
      return Icons.check_circle_outline;
    } else {
      return Icons.security;
    }
  }

  String _getStrengthDescription() {
    if (strength < 0.3) {
      return 'This password is too weak. Add more characters and complexity.';
    } else if (strength < 0.5) {
      return 'Weak password. Consider adding numbers, symbols, or more length.';
    } else if (strength < 0.7) {
      return 'Fair password strength. Adding more complexity would improve security.';
    } else if (strength < 0.9) {
      return 'Good password strength. This should protect your vault well.';
    } else {
      return 'Excellent password strength! This is very secure.';
    }
  }
}