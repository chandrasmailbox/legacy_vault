import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PasswordGeneratorWidget extends StatefulWidget {
  final Function(String) onPasswordGenerated;

  const PasswordGeneratorWidget({super.key, required this.onPasswordGenerated});

  @override
  State<PasswordGeneratorWidget> createState() =>
      _PasswordGeneratorWidgetState();
}

class _PasswordGeneratorWidgetState extends State<PasswordGeneratorWidget> {
  double _passwordLength = 16.0;
  bool _includeUpperCase = true;
  bool _includeLowerCase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  bool _excludeSimilar = true;
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    String upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lowerCase = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '0123456789';
    String symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    if (_excludeSimilar) {
      upperCase = upperCase.replaceAll(RegExp(r'[O0IL1]'), '');
      lowerCase = lowerCase.replaceAll(RegExp(r'[oil1]'), '');
      numbers = numbers.replaceAll(RegExp(r'[01]'), '');
      symbols = symbols.replaceAll(RegExp(r'[|Il1]'), '');
    }

    String characterSet = '';
    List<String> requiredChars = [];

    if (_includeUpperCase) {
      characterSet += upperCase;
      requiredChars.add(upperCase[Random().nextInt(upperCase.length)]);
    }
    if (_includeLowerCase) {
      characterSet += lowerCase;
      requiredChars.add(lowerCase[Random().nextInt(lowerCase.length)]);
    }
    if (_includeNumbers) {
      characterSet += numbers;
      requiredChars.add(numbers[Random().nextInt(numbers.length)]);
    }
    if (_includeSymbols) {
      characterSet += symbols;
      requiredChars.add(symbols[Random().nextInt(symbols.length)]);
    }

    if (characterSet.isEmpty) {
      setState(() {
        _generatedPassword = '';
      });
      return;
    }

    Random random = Random();
    List<String> passwordChars = [];

    // Add required characters first
    passwordChars.addAll(requiredChars);

    // Fill remaining length with random characters
    for (int i = requiredChars.length; i < _passwordLength.toInt(); i++) {
      passwordChars.add(characterSet[random.nextInt(characterSet.length)]);
    }

    // Shuffle the password characters
    passwordChars.shuffle(random);

    setState(() {
      _generatedPassword = passwordChars.join('');
    });
  }

  void _copyPassword() {
    if (_generatedPassword.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withAlpha(
                77,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Text(
                  'Password Generator',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Generated password display
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Generated Password',
                              style: AppTheme.lightTheme.textTheme.labelMedium,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: _copyPassword,
                              icon: CustomIconWidget(
                                iconName: 'copy',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: _generatePassword,
                              icon: CustomIconWidget(
                                iconName: 'refresh',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        SelectableText(
                          _generatedPassword.isNotEmpty
                              ? _generatedPassword
                              : 'No password generated',
                          style: AppTheme.getMonospaceStyle(
                            isLight: true,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Password length slider
                  Text(
                    'Password Length: ${_passwordLength.toInt()}',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  Slider(
                    value: _passwordLength,
                    min: 8,
                    max: 50,
                    divisions: 42,
                    onChanged: (value) {
                      setState(() {
                        _passwordLength = value;
                      });
                      _generatePassword();
                    },
                  ),

                  SizedBox(height: 2.h),

                  // Character options
                  Text(
                    'Character Options',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),

                  SizedBox(height: 1.h),

                  SwitchListTile(
                    title: const Text('Uppercase Letters (A-Z)'),
                    value: _includeUpperCase,
                    onChanged: (value) {
                      setState(() {
                        _includeUpperCase = value;
                      });
                      _generatePassword();
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Lowercase Letters (a-z)'),
                    value: _includeLowerCase,
                    onChanged: (value) {
                      setState(() {
                        _includeLowerCase = value;
                      });
                      _generatePassword();
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Numbers (0-9)'),
                    value: _includeNumbers,
                    onChanged: (value) {
                      setState(() {
                        _includeNumbers = value;
                      });
                      _generatePassword();
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Special Symbols'),
                    value: _includeSymbols,
                    onChanged: (value) {
                      setState(() {
                        _includeSymbols = value;
                      });
                      _generatePassword();
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Exclude Similar Characters'),
                    subtitle: const Text('Avoid O, 0, I, l, 1'),
                    value: _excludeSimilar,
                    onChanged: (value) {
                      setState(() {
                        _excludeSimilar = value;
                      });
                      _generatePassword();
                    },
                  ),

                  const Spacer(),

                  // Use password button
                  ElevatedButton(
                    onPressed:
                        _generatedPassword.isNotEmpty
                            ? () {
                              widget.onPasswordGenerated(_generatedPassword);
                              Navigator.pop(context);
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 6.h),
                    ),
                    child: const Text('Use This Password'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
