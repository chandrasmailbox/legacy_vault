import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final String password;

  const PasswordRequirementsWidget({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password Requirements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.w),
            _buildRequirement(
              context,
              'At least 8 characters',
              password.length >= 8,
            ),
            _buildRequirement(
              context,
              'Contains lowercase letter',
              password.contains(RegExp(r'[a-z]')),
            ),
            _buildRequirement(
              context,
              'Contains uppercase letter',
              password.contains(RegExp(r'[A-Z]')),
            ),
            _buildRequirement(
              context,
              'Contains number',
              password.contains(RegExp(r'[0-9]')),
            ),
            _buildRequirement(
              context,
              'Contains special character',
              password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
            ),
            SizedBox(height: 2.w),
            Divider(height: 2.w),
            SizedBox(height: 2.w),
            Text(
              'Recommended',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            SizedBox(height: 2.w),
            _buildRequirement(
              context,
              '12+ characters for better security',
              password.length >= 12,
              isRecommended: true,
            ),
            _buildRequirement(
              context,
              'Mix of words, numbers, and symbols',
              password.length >= 10 &&
                  password.contains(RegExp(r'[a-z]')) &&
                  password.contains(RegExp(r'[A-Z]')) &&
                  password.contains(RegExp(r'[0-9]')) &&
                  password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
              isRecommended: true,
            ),
            _buildRequirement(
              context,
              'Avoid dictionary words',
              !_containsCommonWords(password),
              isRecommended: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(
    BuildContext context,
    String requirement,
    bool isMet, {
    bool isRecommended = false,
  }) {
    final Color color = isMet
        ? (isRecommended
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary)
        : Theme.of(context).colorScheme.outline;

    final IconData icon = isMet
        ? Icons.check_circle
        : (isRecommended ? Icons.circle_outlined : Icons.cancel_outlined);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.w),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: color,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              requirement,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        isMet ? color : Theme.of(context).colorScheme.onSurface,
                    decoration: isMet ? TextDecoration.none : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  bool _containsCommonWords(String password) {
    final commonWords = [
      'password',
      'admin',
      'user',
      'test',
      'guest',
      'login',
      '123456',
      'qwerty',
      'abc123',
      'password123',
      'admin123',
      'welcome',
      'hello',
      'world',
      'secret',
      'master',
    ];

    final lowerPassword = password.toLowerCase();
    return commonWords.any((word) => lowerPassword.contains(word));
  }
}