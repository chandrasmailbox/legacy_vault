import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/inheritance_settings_widget.dart';
import './widgets/password_form_widget.dart';
import './widgets/password_generator_bottom_sheet.dart';

class AddEditPassword extends StatefulWidget {
  final Map<String, dynamic>? passwordData;

  const AddEditPassword({Key? key, this.passwordData}) : super(key: key);

  @override
  State<AddEditPassword> createState() => _AddEditPasswordState();
}

class _AddEditPasswordState extends State<AddEditPassword> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _websiteController = TextEditingController();
  final _notesController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isPasswordVisible = false;
  bool _includeInDigitalWill = false;
  String _selectedCategory = 'Personal';
  List<String> _selectedFamilyMembers = [];
  bool _hasUnsavedChanges = false;
  int _passwordStrength = 0;

  final List<String> _categories = [
    'Banking',
    'Social',
    'Work',
    'Personal',
    'Other'
  ];
  final List<String> _serviceNameSuggestions = [
    'Gmail',
    'Facebook',
    'Instagram',
    'Twitter',
    'LinkedIn',
    'Netflix',
    'Amazon',
    'Apple ID',
    'Microsoft',
    'Google',
    'Dropbox',
    'Spotify',
    'PayPal',
    'Bank of America'
  ];

  final List<Map<String, dynamic>> _familyMembers = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "relationship": "Spouse",
      "email": "sarah.johnson@email.com",
      "phone": "+1 (555) 123-4567",
      "isEmergencyContact": true,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
    },
    {
      "id": 2,
      "name": "Michael Johnson",
      "relationship": "Son",
      "email": "michael.johnson@email.com",
      "phone": "+1 (555) 234-5678",
      "isEmergencyContact": false,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
    },
    {
      "id": 3,
      "name": "Emma Johnson",
      "relationship": "Daughter",
      "email": "emma.johnson@email.com",
      "phone": "+1 (555) 345-6789",
      "isEmergencyContact": false,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _addTextFieldListeners();
  }

  void _initializeFormData() {
    if (widget.passwordData != null) {
      final data = widget.passwordData!;
      _serviceNameController.text = data['serviceName'] ?? '';
      _usernameController.text = data['username'] ?? '';
      _passwordController.text = data['password'] ?? '';
      _websiteController.text = data['website'] ?? '';
      _notesController.text = data['notes'] ?? '';
      _selectedCategory = data['category'] ?? 'Personal';
      _includeInDigitalWill = data['includeInDigitalWill'] ?? false;
      _selectedFamilyMembers =
          List<String>.from(data['selectedFamilyMembers'] ?? []);
      _calculatePasswordStrength();
    }
  }

  void _addTextFieldListeners() {
    _serviceNameController.addListener(_onFormChanged);
    _usernameController.addListener(_onFormChanged);
    _passwordController.addListener(() {
      _onFormChanged();
      _calculatePasswordStrength();
    });
    _websiteController.addListener(_onFormChanged);
    _notesController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _calculatePasswordStrength() {
    final password = _passwordController.text;
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength++;

    setState(() {
      _passwordStrength = strength;
    });
  }

  void _showPasswordGenerator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PasswordGeneratorBottomSheet(
        onPasswordGenerated: (password) {
          setState(() {
            _passwordController.text = password;
            _hasUnsavedChanges = true;
          });
          _calculatePasswordStrength();
        },
      ),
    );
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();

      final passwordData = {
        'serviceName': _serviceNameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'website': _websiteController.text,
        'notes': _notesController.text,
        'category': _selectedCategory,
        'includeInDigitalWill': _includeInDigitalWill,
        'selectedFamilyMembers': _selectedFamilyMembers,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.passwordData != null
                ? 'Password updated successfully'
                : 'Password saved successfully',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
        ),
      );

      Navigator.pushReplacementNamed(context, '/password-vault');
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Unsaved Changes',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Leave',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            widget.passwordData != null ? 'Edit Password' : 'Add Password',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: _savePassword,
              child: Text(
                'Save',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
          elevation: 0,
          backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PasswordFormWidget(
                  serviceNameController: _serviceNameController,
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  websiteController: _websiteController,
                  notesController: _notesController,
                  isPasswordVisible: _isPasswordVisible,
                  passwordStrength: _passwordStrength,
                  selectedCategory: _selectedCategory,
                  categories: _categories,
                  serviceNameSuggestions: _serviceNameSuggestions,
                  onPasswordVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  onGeneratePassword: _showPasswordGenerator,
                  onCategoryChanged: (category) {
                    setState(() {
                      _selectedCategory = category;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 6.h),
                InheritanceSettingsWidget(
                  includeInDigitalWill: _includeInDigitalWill,
                  selectedFamilyMembers: _selectedFamilyMembers,
                  familyMembers: _familyMembers,
                  onIncludeInDigitalWillChanged: (value) {
                    setState(() {
                      _includeInDigitalWill = value;
                      _hasUnsavedChanges = true;
                      if (!value) {
                        _selectedFamilyMembers.clear();
                      }
                    });
                  },
                  onFamilyMemberSelectionChanged: (members) {
                    setState(() {
                      _selectedFamilyMembers = members;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _serviceNameController.text.isNotEmpty &&
                            _usernameController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty
                        ? () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Testing login credentials...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                    icon: CustomIconWidget(
                      iconName: 'verified_user',
                      color: _serviceNameController.text.isNotEmpty &&
                              _usernameController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                      size: 20,
                    ),
                    label: Text('Test Login'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
