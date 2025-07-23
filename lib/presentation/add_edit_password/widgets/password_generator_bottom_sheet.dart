import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PasswordGeneratorBottomSheet extends StatefulWidget {
  final Function(String) onPasswordGenerated;

  const PasswordGeneratorBottomSheet({
    Key? key,
    required this.onPasswordGenerated,
  }) : super(key: key);

  @override
  State<PasswordGeneratorBottomSheet> createState() =>
      _PasswordGeneratorBottomSheetState();
}

class _PasswordGeneratorBottomSheetState
    extends State<PasswordGeneratorBottomSheet> {
  double _passwordLength = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  bool _pronounceable = false;
  String _generatedPassword = '';

  final List<String> _pronounceableWords = [
    'apple',
    'brave',
    'cloud',
    'dream',
    'eagle',
    'flame',
    'grace',
    'heart',
    'light',
    'magic',
    'ocean',
    'peace',
    'quick',
    'river',
    'storm',
    'trust',
    'unity',
    'voice',
    'water',
    'youth',
    'zebra',
    'amber',
    'beach',
    'coral',
  ];

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    String password;

    if (_pronounceable) {
      password = _generatePronounceablePassword();
    } else {
      password = _generateRandomPassword();
    }

    setState(() {
      _generatedPassword = password;
    });
  }

  String _generateRandomPassword() {
    String chars = '';
    if (_includeLowercase) chars += 'abcdefghijklmnopqrstuvwxyz';
    if (_includeUppercase) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_includeNumbers) chars += '0123456789';
    if (_includeSymbols) chars += '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    if (chars.isEmpty) return '';

    Random random = Random.secure();
    return List.generate(
      _passwordLength.toInt(),
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  String _generatePronounceablePassword() {
    Random random = Random.secure();
    List<String> selectedWords = [];

    int wordCount = (_passwordLength / 6).ceil().clamp(2, 4);

    for (int i = 0; i < wordCount; i++) {
      String word =
          _pronounceableWords[random.nextInt(_pronounceableWords.length)];
      if (_includeUppercase && i == 0) {
        word = word[0].toUpperCase() + word.substring(1);
      }
      selectedWords.add(word);
    }

    String password = selectedWords.join('');

    if (_includeNumbers) {
      password += random.nextInt(100).toString();
    }

    if (_includeSymbols) {
      List<String> symbols = ['!', '@', '#', '\$', '%'];
      password += symbols[random.nextInt(symbols.length)];
    }

    return password.length > _passwordLength
        ? password.substring(0, _passwordLength.toInt())
        : password;
  }

  int _calculatePasswordStrength() {
    int strength = 0;

    if (_generatedPassword.length >= 8) strength++;
    if (_generatedPassword.length >= 12) strength++;
    if (RegExp(r'[A-Z]').hasMatch(_generatedPassword)) strength++;
    if (RegExp(r'[a-z]').hasMatch(_generatedPassword)) strength++;
    if (RegExp(r'[0-9]').hasMatch(_generatedPassword)) strength++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(_generatedPassword)) strength++;

    return strength;
  }

  Color _getPasswordStrengthColor() {
    int strength = _calculatePasswordStrength();
    if (strength <= 2) return AppTheme.lightTheme.colorScheme.error;
    if (strength <= 4) return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.lightTheme.colorScheme.primary;
  }

  String _getPasswordStrengthText() {
    int strength = _calculatePasswordStrength();
    if (strength <= 2) return 'Weak';
    if (strength <= 4) return 'Medium';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'auto_fix_high',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Password Generator',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Generated Password Display
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Generated Password',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: _generatedPassword),
                                );
                                HapticFeedback.lightImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Password copied to clipboard',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: CustomIconWidget(
                                iconName: 'copy',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              tooltip: 'Copy Password',
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            _generatedPassword,
                            style: AppTheme.getMonospaceStyle(
                              isLight: true,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Password Strength
                        Row(
                          children: [
                            Text(
                              'Strength: ',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: _calculatePasswordStrength() / 6,
                                backgroundColor: AppTheme
                                    .lightTheme
                                    .colorScheme
                                    .outline
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
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _getPasswordStrengthColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Password Length
                  Text(
                    'Password Length',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _passwordLength,
                          min: 8,
                          max: 32,
                          divisions: 24,
                          label: _passwordLength.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _passwordLength = value;
                            });
                            _generatePassword();
                          },
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Container(
                        width: 12.w,
                        padding: EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 2.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _passwordLength.round().toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Character Options
                  Text(
                    'Character Options',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  _buildOptionTile(
                    'Uppercase Letters (A-Z)',
                    _includeUppercase,
                    (value) {
                      setState(() {
                        _includeUppercase = value;
                      });
                      _generatePassword();
                    },
                  ),

                  _buildOptionTile(
                    'Lowercase Letters (a-z)',
                    _includeLowercase,
                    (value) {
                      setState(() {
                        _includeLowercase = value;
                      });
                      _generatePassword();
                    },
                  ),

                  _buildOptionTile('Numbers (0-9)', _includeNumbers, (value) {
                    setState(() {
                      _includeNumbers = value;
                    });
                    _generatePassword();
                  }),

                  _buildOptionTile('Symbols (!@#\$%^&*)', _includeSymbols, (
                    value,
                  ) {
                    setState(() {
                      _includeSymbols = value;
                    });
                    _generatePassword();
                  }),

                  _buildOptionTile(
                    'Pronounceable',
                    _pronounceable,
                    (value) {
                      setState(() {
                        _pronounceable = value;
                      });
                      _generatePassword();
                    },
                    subtitle: 'Generate easier to remember passwords',
                  ),

                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),

          // Bottom Actions
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline.withValues(
                    alpha: 0.2,
                  ),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _generatePassword,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Regenerate'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      widget.onPasswordGenerated(_generatedPassword);
                      Navigator.of(context).pop();
                    },
                    icon: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text('Use Password'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    String title,
    bool value,
    Function(bool) onChanged, {
    String? subtitle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
                  ),
                )
                : null,
        value: value,
        onChanged: onChanged,
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      ),
    );
  }
}
