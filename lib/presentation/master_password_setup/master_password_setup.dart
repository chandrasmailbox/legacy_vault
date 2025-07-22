import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/master_password_form_widget.dart';
import './widgets/password_requirements_widget.dart';
import './widgets/password_strength_widget.dart';

class MasterPasswordSetup extends StatefulWidget {
  const MasterPasswordSetup({super.key});

  @override
  State<MasterPasswordSetup> createState() => _MasterPasswordSetupState();
}

class _MasterPasswordSetupState extends State<MasterPasswordSetup> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'Very Weak';
  Color _passwordStrengthColor = Colors.red;
  bool _isExistingUser = false;

  final TextEditingController _currentPasswordController =
      TextEditingController();
  bool _obscureCurrentPassword = true;

  @override
  void initState() {
    super.initState();
    // Check if user already has a master password
    _checkExistingUser();
    _passwordController.addListener(_evaluatePasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  void _checkExistingUser() {
    // TODO: Check if user already has a master password set
    // For demo purposes, we'll get this from arguments or assume new user
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    setState(() {
      _isExistingUser = args?['isExistingUser'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isExistingUser ? 'Change Master Password' : 'Set Master Password',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withAlpha(77),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      size: 48.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 3.w),
                    Text(
                      _isExistingUser
                          ? 'Update Your Master Password'
                          : 'Secure Your Digital Legacy',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      _isExistingUser
                          ? 'Your master password protects all your vault data. Choose a strong, unique password.'
                          : 'Your master password is the key to your entire vault. Make it strong and memorable - you\'ll need it to access all your stored passwords.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.w),

              // Current Password (for existing users)
              if (_isExistingUser) ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Master Password',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 3.w),
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: _obscureCurrentPassword,
                          decoration: InputDecoration(
                            hintText: 'Enter your current master password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureCurrentPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureCurrentPassword =
                                      !_obscureCurrentPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current master password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4.w),
              ],

              // Master Password Form
              MasterPasswordFormWidget(
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                obscurePassword: _obscurePassword,
                obscureConfirmPassword: _obscureConfirmPassword,
                onTogglePasswordVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                onToggleConfirmPasswordVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),

              SizedBox(height: 4.w),

              // Password Strength Indicator
              PasswordStrengthWidget(
                strength: _passwordStrength,
                strengthText: _passwordStrengthText,
                strengthColor: _passwordStrengthColor,
              ),

              SizedBox(height: 4.w),

              // Password Requirements
              PasswordRequirementsWidget(
                password: _passwordController.text,
              ),

              SizedBox(height: 6.w),

              // Security Tips
              Card(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Master Password Tips',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.w),
                      _buildTipItem('Use a passphrase with 4+ words'),
                      _buildTipItem('Include numbers and special characters'),
                      _buildTipItem('Avoid dictionary words and personal info'),
                      _buildTipItem('Make it memorable but not obvious'),
                      _buildTipItem('Never share it with anyone'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 6.w),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _passwordStrength >= 0.6
                          ? () => _setMasterPassword()
                          : null,
                      child: Text(
                        _isExistingUser
                            ? 'Update Master Password'
                            : 'Set Master Password',
                      ),
                    ),
                  ),
                  SizedBox(height: 3.w),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _generateSecurePassword(),
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Generate Secure Password'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.w),
            width: 1.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _evaluatePasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthText = 'Very Weak';
        _passwordStrengthColor = Colors.red;
      });
      return;
    }

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.length >= 16) score++;

    // Character variety
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    // Complexity patterns
    if (password.length >= 10 &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score++;
    }

    final strength = score / 8.0;
    String strengthText;
    Color strengthColor;

    if (strength < 0.3) {
      strengthText = 'Very Weak';
      strengthColor = Colors.red;
    } else if (strength < 0.5) {
      strengthText = 'Weak';
      strengthColor = Colors.orange;
    } else if (strength < 0.7) {
      strengthText = 'Fair';
      strengthColor = Colors.yellow;
    } else if (strength < 0.9) {
      strengthText = 'Good';
      strengthColor = Colors.lightGreen;
    } else {
      strengthText = 'Excellent';
      strengthColor = Colors.green;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }

  void _generateSecurePassword() {
    // Generate a secure password suggestion
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final List<String> words = [
      'Sunset',
      'Mountain',
      'River',
      'Ocean',
      'Forest',
      'Garden',
      'Bridge',
      'Castle'
    ];
    final random = DateTime.now().millisecondsSinceEpoch;

    final word1 = words[random % words.length];
    final word2 = words[(random + 1) % words.length];
    final numbers = '${random % 100}';
    final special = chars.substring(62)[(random + 2) % 10];

    final suggestion = '$word1$word2$numbers$special';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generated Password Suggestion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Here\'s a strong password suggestion:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: SelectableText(
                suggestion,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Make sure to memorize this password or store it securely. You\'ll need it to access your vault.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _passwordController.text = suggestion;
              _confirmPasswordController.text = suggestion;
              _evaluatePasswordStrength();
              Navigator.pop(context);
            },
            child: const Text('Use This Password'),
          ),
        ],
      ),
    );
  }

  void _setMasterPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordStrength < 0.6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Password is too weak. Please choose a stronger password.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isExistingUser
            ? 'Confirm Password Change'
            : 'Confirm Master Password'),
        content: Text(
          _isExistingUser
              ? 'Are you sure you want to change your master password? You\'ll need to use the new password for all future vault access.'
              : 'Are you sure you want to set this as your master password? Make sure you can remember it - there\'s no way to recover it if forgotten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveMasterPassword();
            },
            child: Text(_isExistingUser ? 'Change Password' : 'Set Password'),
          ),
        ],
      ),
    );
  }

  void _saveMasterPassword() {
    // TODO: Implement actual master password storage with encryption
    // For now, show success message

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isExistingUser
              ? 'Master password updated successfully!'
              : 'Master password set successfully!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or to main screen
    Navigator.of(context).pop();
  }
}