import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/check_in_interval_widget.dart';
import './widgets/emergency_contact_widget.dart';
import './widgets/family_member_card_widget.dart';
import './widgets/inheritance_delay_widget.dart';
import './widgets/setup_progress_widget.dart';

class DigitalWillSetup extends StatefulWidget {
  const DigitalWillSetup({Key? key}) : super(key: key);

  @override
  State<DigitalWillSetup> createState() => _DigitalWillSetupState();
}

class _DigitalWillSetupState extends State<DigitalWillSetup> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Setup data
  String _selectedInterval = 'monthly';
  List<Map<String, dynamic>> _familyMembers = [];
  int _inheritanceDelayDays = 7;
  String? _emergencyContactId;
  bool _isSetupComplete = false;

  // Mock family members data
  final List<Map<String, dynamic>> _mockFamilyMembers = [
    {
      "id": "1",
      "name": "Sarah Johnson",
      "relationship": "Spouse",
      "email": "sarah.johnson@email.com",
      "phone": "+1 (555) 123-4567",
      "isEmergencyContact": false,
    },
    {
      "id": "2",
      "name": "Michael Johnson",
      "relationship": "Son",
      "email": "michael.johnson@email.com",
      "phone": "+1 (555) 234-5678",
      "isEmergencyContact": false,
    },
    {
      "id": "3",
      "name": "Emma Johnson",
      "relationship": "Daughter",
      "email": "emma.johnson@email.com",
      "phone": "+1 (555) 345-6789",
      "isEmergencyContact": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _familyMembers = List.from(_mockFamilyMembers);
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateInterval(String interval) {
    setState(() {
      _selectedInterval = interval;
    });
  }

  void _addFamilyMember() {
    // Simulate adding a new family member
    final newMember = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "name": "New Family Member",
      "relationship": "Other",
      "email": "new.member@email.com",
      "phone": "+1 (555) 000-0000",
      "isEmergencyContact": false,
    };

    setState(() {
      _familyMembers.add(newMember);
    });
  }

  void _removeFamilyMember(String id) {
    setState(() {
      _familyMembers.removeWhere((member) => member["id"] == id);
      if (_emergencyContactId == id) {
        _emergencyContactId = null;
      }
    });
  }

  void _updateInheritanceDelay(int days) {
    setState(() {
      _inheritanceDelayDays = days;
    });
  }

  void _setEmergencyContact(String? contactId) {
    setState(() {
      _emergencyContactId = contactId;
    });
  }

  void _testNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Test notification sent to emergency contact',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _completeSetup() {
    if (_validateSetup()) {
      setState(() {
        _isSetupComplete = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Digital Will setup completed successfully!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.successLight,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to password vault after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/password-vault');
      });
    }
  }

  bool _validateSetup() {
    if (_familyMembers.isEmpty) {
      _showErrorMessage('Please add at least one family member');
      return false;
    }

    if (_emergencyContactId == null) {
      _showErrorMessage('Please designate an emergency contact');
      return false;
    }

    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.errorLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Digital Will Setup',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading:
            _currentStep > 0
                ? IconButton(
                  onPressed: _previousStep,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                )
                : IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
      ),
      body: Column(
        children: [
          // Progress indicator
          SetupProgressWidget(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildIntroductionStep(),
                _buildCheckInIntervalStep(),
                _buildFamilyMembersStep(),
                _buildFinalSetupStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          // Header
          Text(
            'Welcome to Digital Will Setup',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          // Explanation card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline.withValues(
                  alpha: 0.2,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'security',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Secure Offline Inheritance',
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Your digital will ensures that your important passwords and digital assets are securely transferred to your family members when needed. Everything is stored locally on your device - no cloud storage required.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                _buildFeatureItem(
                  'check_circle',
                  'Proof-of-life check-ins',
                  'Regular confirmations that you\'re active',
                ),
                SizedBox(height: 1.h),
                _buildFeatureItem(
                  'family_restroom',
                  'Family member nominations',
                  'Designate trusted family members as inheritors',
                ),
                SizedBox(height: 1.h),
                _buildFeatureItem(
                  'timer',
                  'Dead man\'s switch',
                  'Automatic inheritance after missed check-ins',
                ),
                SizedBox(height: 1.h),
                _buildFeatureItem(
                  'lock',
                  'Local encryption',
                  'All data stays secure on your device',
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Text(
                  'Begin Setup',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String iconName, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.successLight,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(description, style: AppTheme.lightTheme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInIntervalStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Text(
            'Proof-of-Life Check-ins',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Set how often you\'ll confirm you\'re active. Missing check-ins will trigger the inheritance process.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 3.h),
          CheckInIntervalWidget(
            selectedInterval: _selectedInterval,
            onIntervalChanged: _updateInterval,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: AppTheme.lightTheme.outlinedButtonTheme.style,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text('Back'),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: AppTheme.lightTheme.elevatedButtonTheme.style,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      'Continue',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMembersStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          Text(
            'Family Members',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Add family members who will inherit your digital assets. You can add them from your contacts or manually.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),

          SizedBox(height: 3.h),

          // Add family member button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addFamilyMember,
              style: AppTheme.lightTheme.outlinedButtonTheme.style?.copyWith(
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text('Add Family Member'),
            ),
          ),

          SizedBox(height: 3.h),

          // Family members list
          _familyMembers.isEmpty
              ? Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'family_restroom',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No family members added yet',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Add at least one family member to continue',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : Column(
                children:
                    _familyMembers.map((member) {
                      return FamilyMemberCardWidget(
                        member: member,
                        onRemove:
                            () => _removeFamilyMember(member["id"] as String),
                        onEdit: () {
                          // Handle edit functionality
                        },
                      );
                    }).toList(),
              ),

          SizedBox(height: 4.h),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: AppTheme.lightTheme.outlinedButtonTheme.style,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text('Back'),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _familyMembers.isNotEmpty ? _nextStep : null,
                  style: AppTheme.lightTheme.elevatedButtonTheme.style,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      'Continue',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalSetupStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          Text(
            'Final Configuration',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Configure inheritance delay and emergency contact settings.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),

          SizedBox(height: 3.h),

          // Inheritance delay widget
          InheritanceDelayWidget(
            delayDays: _inheritanceDelayDays,
            onDelayChanged: _updateInheritanceDelay,
          ),

          SizedBox(height: 3.h),

          // Emergency contact widget
          EmergencyContactWidget(
            familyMembers: _familyMembers,
            selectedContactId: _emergencyContactId,
            onContactSelected: _setEmergencyContact,
            onTestNotification: _testNotification,
          ),

          SizedBox(height: 3.h),

          // Process explanation
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'How Inheritance Works',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  '1. You\'ll receive regular check-in reminders\n'
                  '2. Missing check-ins triggers a countdown\n'
                  '3. Emergency contacts receive notifications\n'
                  '4. After the delay period, secure data transfer begins\n'
                  '5. Family members receive access instructions',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: AppTheme.lightTheme.outlinedButtonTheme.style,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text('Back'),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSetupComplete ? null : _completeSetup,
                  style: AppTheme.lightTheme.elevatedButtonTheme.style
                      ?.copyWith(
                        backgroundColor: WidgetStateProperty.all(
                          _isSetupComplete
                              ? AppTheme.successLight
                              : AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child:
                        _isSetupComplete
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Setup Complete',
                                  style: AppTheme
                                      .lightTheme
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            )
                            : Text(
                              'Complete Setup',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
