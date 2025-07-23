import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/beneficiary_overview_widget.dart';
import './widgets/inheritance_status_widget.dart';
import './widgets/inheritance_timeline_widget.dart';
import './widgets/proof_of_life_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';

class InheritanceStatusDashboard extends StatefulWidget {
  const InheritanceStatusDashboard({super.key});

  @override
  State<InheritanceStatusDashboard> createState() =>
      _InheritanceStatusDashboardState();
}

class _InheritanceStatusDashboardState extends State<InheritanceStatusDashboard>
    with TickerProviderStateMixin {
  late Timer _countdownTimer;
  Duration _timeToNextCheckIn = const Duration(days: 7, hours: 3, minutes: 45);
  String _inheritanceStatus = 'active'; // active, warning, triggered

  // Mock data for beneficiaries
  final List<Map<String, dynamic>> _beneficiaries = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "relationship": "Daughter",
      "email": "sarah.johnson@email.com",
      "phone": "+1 (555) 123-4567",
      "accessLevel": "Full Access",
      "verificationStatus": "Verified",
      "inheritedItemsCount": 45,
      "categories": {"Banking": 12, "Personal": 18, "Work": 15},
      "lastNotification": "2025-07-20",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b388?w=100&h=100&fit=crop&crop=face",
    },
    {
      "id": 2,
      "name": "Michael Johnson",
      "relationship": "Son",
      "email": "michael.j@email.com",
      "phone": "+1 (555) 987-6543",
      "accessLevel": "Limited Access",
      "verificationStatus": "Pending",
      "inheritedItemsCount": 28,
      "categories": {"Banking": 8, "Personal": 12, "Work": 8},
      "lastNotification": "2025-07-18",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face",
    },
    {
      "id": 3,
      "name": "Emma Wilson",
      "relationship": "Sister",
      "email": "emma.wilson@email.com",
      "phone": "+1 (555) 456-7890",
      "accessLevel": "Emergency Only",
      "verificationStatus": "Verified",
      "inheritedItemsCount": 12,
      "categories": {"Banking": 2, "Personal": 8, "Work": 2},
      "lastNotification": "2025-07-21",
      "avatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face",
    },
  ];

  // Recent activity mock data
  final List<Map<String, dynamic>> _recentActivity = [
    {
      "id": 1,
      "type": "check_in",
      "title": "Proof of Life Check-in",
      "description": "Successfully completed manual check-in",
      "timestamp": "2025-07-20 14:30:00",
      "icon": "check_circle",
      "color": "success",
    },
    {
      "id": 2,
      "type": "beneficiary_added",
      "title": "New Beneficiary Added",
      "description": "Emma Wilson added as Emergency contact",
      "timestamp": "2025-07-19 10:15:00",
      "icon": "person_add",
      "color": "info",
    },
    {
      "id": 3,
      "type": "test_inheritance",
      "title": "Inheritance Process Test",
      "description": "Test inheritance workflow completed successfully",
      "timestamp": "2025-07-18 16:45:00",
      "icon": "science",
      "color": "info",
    },
    {
      "id": 4,
      "type": "schedule_modified",
      "title": "Check-in Schedule Modified",
      "description": "Check-in interval changed to 7 days",
      "timestamp": "2025-07-17 09:20:00",
      "icon": "schedule",
      "color": "warning",
    },
  ];

  late AnimationController _statusAnimationController;
  late Animation<double> _statusAnimation;

  @override
  void initState() {
    super.initState();
    _statusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _statusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _statusAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _statusAnimationController.forward();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _statusAnimationController.dispose();
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeToNextCheckIn.inSeconds > 0) {
          _timeToNextCheckIn = _timeToNextCheckIn - const Duration(seconds: 1);

          // Update status based on time remaining
          if (_timeToNextCheckIn.inDays <= 1) {
            _inheritanceStatus = 'warning';
          } else if (_timeToNextCheckIn.inSeconds <= 0) {
            _inheritanceStatus = 'triggered';
          } else {
            _inheritanceStatus = 'active';
          }
        }
      });
    });
  }

  void _performCheckIn() {
    setState(() {
      _timeToNextCheckIn = const Duration(days: 7);
      _inheritanceStatus = 'active';
    });

    // Add to recent activity
    final newActivity = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "type": "check_in",
      "title": "Manual Check-in Completed",
      "description": "Proof of life confirmed, next check-in in 7 days",
      "timestamp": DateTime.now().toString(),
      "icon": "check_circle",
      "color": "success",
    };

    setState(() {
      _recentActivity.insert(0, newActivity);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Check-in completed successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _testInheritanceProcess() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Test Inheritance Process'),
            content: const Text(
              'This will simulate the complete inheritance workflow without actually triggering it. Test notifications will be sent to all beneficiaries.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _runInheritanceTest();
                },
                child: const Text('Start Test'),
              ),
            ],
          ),
    );
  }

  void _runInheritanceTest() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Running inheritance test...'),
              ],
            ),
          ),
    );

    // Simulate test process
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);

      final testActivity = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "type": "test_inheritance",
        "title": "Inheritance Test Completed",
        "description":
            "All systems functioning correctly, test notifications sent",
        "timestamp": DateTime.now().toString(),
        "icon": "science",
        "color": "success",
      };

      setState(() {
        _recentActivity.insert(0, testActivity);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inheritance process test completed successfully!'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Inheritance Dashboard'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Show notifications
                },
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              if (_inheritanceStatus == 'warning' ||
                  _inheritanceStatus == 'triggered')
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          _inheritanceStatus == 'triggered'
                              ? AppTheme.lightTheme.colorScheme.error
                              : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inheritance status header
              AnimatedBuilder(
                animation: _statusAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _statusAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _statusAnimation.value)),
                      child: InheritanceStatusWidget(
                        status: _inheritanceStatus,
                        timeToNextCheckIn: _timeToNextCheckIn,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 3.h),

              // Proof of life check-in
              ProofOfLifeWidget(
                timeToNextCheckIn: _timeToNextCheckIn,
                onCheckIn: _performCheckIn,
                onEmergencyDelay: () {
                  // Handle emergency delay
                  setState(() {
                    _timeToNextCheckIn =
                        _timeToNextCheckIn + const Duration(days: 3);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Emergency delay of 3 days added'),
                    ),
                  );
                },
              ),

              SizedBox(height: 3.h),

              // Beneficiary overview
              BeneficiaryOverviewWidget(
                beneficiaries: _beneficiaries,
                onViewAll: () {
                  Navigator.pushNamed(context, '/family-management');
                },
                onModifyPermissions: (beneficiaryId) {
                  // Handle permission modification
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening permission settings...'),
                    ),
                  );
                },
              ),

              SizedBox(height: 3.h),

              // Inheritance timeline
              InheritanceTimelineWidget(
                currentStatus: _inheritanceStatus,
                timeToNextCheckIn: _timeToNextCheckIn,
              ),

              SizedBox(height: 3.h),

              // Quick actions
              QuickActionsWidget(
                onCheckIn: _performCheckIn,
                onModifySchedule: () {
                  // Navigate to schedule modification
                  Navigator.pushNamed(context, '/digital-will-setup');
                },
                onAddBeneficiary: () {
                  Navigator.pushNamed(context, '/family-management');
                },
                onEmergencyContact: () {
                  // Show emergency contact options
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening emergency contact settings...'),
                    ),
                  );
                },
                onTestInheritance: _testInheritanceProcess,
              ),

              SizedBox(height: 3.h),

              // Recent activity
              RecentActivityWidget(
                activities: _recentActivity.take(5).toList(),
                onViewAll: () {
                  // Show full activity log
                },
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
