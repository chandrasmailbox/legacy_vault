import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/family_member_card_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/inheritance_stats_widget.dart';

class FamilyManagement extends StatefulWidget {
  const FamilyManagement({Key? key}) : super(key: key);

  @override
  State<FamilyManagement> createState() => _FamilyManagementState();
}

class _FamilyManagementState extends State<FamilyManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All Members';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _familyMembers = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "relationship": "Spouse",
      "email": "sarah.johnson@email.com",
      "phone": "+1 (555) 123-4567",
      "profileImage":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "accessLevel": "Full Access",
      "status": "active",
      "inheritedItems": 45,
      "lastContact": "2025-07-10",
      "contactVerified": true,
      "emergencyContact": false
    },
    {
      "id": 2,
      "name": "Michael Johnson",
      "relationship": "Son",
      "email": "michael.j@email.com",
      "phone": "+1 (555) 987-6543",
      "profileImage":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "accessLevel": "Limited Access",
      "status": "active",
      "inheritedItems": 12,
      "lastContact": "2025-07-08",
      "contactVerified": true,
      "emergencyContact": false
    },
    {
      "id": 3,
      "name": "Emma Johnson",
      "relationship": "Daughter",
      "email": "emma.johnson@email.com",
      "phone": "+1 (555) 456-7890",
      "profileImage":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "accessLevel": "Limited Access",
      "status": "verification_needed",
      "inheritedItems": 8,
      "lastContact": "2025-06-25",
      "contactVerified": false,
      "emergencyContact": false
    },
    {
      "id": 4,
      "name": "Robert Smith",
      "relationship": "Brother",
      "email": "robert.smith@email.com",
      "phone": "+1 (555) 321-0987",
      "profileImage":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "accessLevel": "Emergency Contact Only",
      "status": "active",
      "inheritedItems": 0,
      "lastContact": "2025-07-05",
      "contactVerified": true,
      "emergencyContact": true
    },
    {
      "id": 5,
      "name": "Lisa Davis",
      "relationship": "Sister",
      "email": "lisa.davis@email.com",
      "phone": "+1 (555) 654-3210",
      "profileImage":
          "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
      "accessLevel": "Emergency Contact Only",
      "status": "unreachable",
      "inheritedItems": 0,
      "lastContact": "2025-06-15",
      "contactVerified": false,
      "emergencyContact": true
    }
  ];

  final List<String> _filterOptions = [
    'All Members',
    'Active Inheritors',
    'Emergency Contacts',
    'Verification Needed'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredMembers {
    List<Map<String, dynamic>> filtered = _familyMembers;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((member) {
        final name = (member['name'] as String).toLowerCase();
        final relationship = (member['relationship'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || relationship.contains(query);
      }).toList();
    }

    // Apply category filter
    switch (_selectedFilter) {
      case 'Active Inheritors':
        filtered = filtered
            .where((member) =>
                (member['accessLevel'] as String) != 'Emergency Contact Only' &&
                (member['status'] as String) == 'active')
            .toList();
        break;
      case 'Emergency Contacts':
        filtered = filtered
            .where((member) => (member['emergencyContact'] as bool) == true)
            .toList();
        break;
      case 'Verification Needed':
        filtered = filtered
            .where((member) => (member['contactVerified'] as bool) == false)
            .toList();
        break;
    }

    return filtered;
  }

  int get _totalInheritedItems {
    return _familyMembers.fold(
        0, (sum, member) => sum + (member['inheritedItems'] as int));
  }

  int get _activeInheritors {
    return _familyMembers
        .where((member) =>
            (member['accessLevel'] as String) != 'Emergency Contact Only' &&
            (member['status'] as String) == 'active')
        .length;
  }

  int get _verificationNeeded {
    return _familyMembers
        .where((member) => (member['contactVerified'] as bool) == false)
        .length;
  }

  void _showAddFamilyMemberDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Family Member',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'contacts',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                title: Text('From Contacts'),
                subtitle: Text('Select from your phone contacts'),
                onTap: () {
                  Navigator.pop(context);
                  _showContactPicker();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'person_add',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                title: Text('Manual Entry'),
                subtitle: Text('Enter details manually'),
                onTap: () {
                  Navigator.pop(context);
                  _showManualEntryForm();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showContactPicker() {
    // Simulate contact picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact picker would open here'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _showManualEntryForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Family Member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Relationship',
                    prefixIcon: CustomIconWidget(
                      iconName: 'family_restroom',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: CustomIconWidget(
                      iconName: 'email',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Family member added successfully'),
                    backgroundColor: AppTheme.successLight,
                  ),
                );
              },
              child: Text('Add Member'),
            ),
          ],
        );
      },
    );
  }

  void _sendTestNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Test Notifications'),
          content: Text(
              'This will send test notifications to all family members to verify their contact information. Continue?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Test notifications sent to ${_familyMembers.length} members'),
                    backgroundColor: AppTheme.successLight,
                  ),
                );
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Legacy Vault'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              text: 'Biometric',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'family_restroom',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              text: 'Family',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              text: 'Digital Will',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              text: 'Vault',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              text: 'Add Password',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              text: 'Check-in',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/biometric-authentication-setup');
                break;
              case 1:
                // Current screen
                break;
              case 2:
                Navigator.pushNamed(context, '/digital-will-setup');
                break;
              case 3:
                Navigator.pushNamed(context, '/password-vault');
                break;
              case 4:
                Navigator.pushNamed(context, '/add-edit-password');
                break;
              case 5:
                Navigator.pushNamed(context, '/proof-of-life-check-in');
                break;
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(), // Biometric placeholder
          _buildFamilyManagementContent(), // Current screen
          Container(), // Digital Will placeholder
          Container(), // Vault placeholder
          Container(), // Add Password placeholder
          Container(), // Check-in placeholder
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: _showAddFamilyMemberDialog,
              icon: CustomIconWidget(
                iconName: 'person_add',
                color: Colors.white,
                size: 24,
              ),
              label: Text('Add Family Member'),
            )
          : null,
    );
  }

  Widget _buildFamilyManagementContent() {
    return Column(
      children: [
        // Header with stats
        Container(
          padding: EdgeInsets.all(4.w),
          child: InheritanceStatsWidget(
            totalMembers: _familyMembers.length,
            activeInheritors: _activeInheritors,
            totalInheritedItems: _totalInheritedItems,
            verificationNeeded: _verificationNeeded,
          ),
        ),

        // Search bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search family members...',
              prefixIcon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        SizedBox(height: 2.h),

        // Filter chips
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: FilterChipsWidget(
            options: _filterOptions,
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
        ),

        SizedBox(height: 2.h),

        // Family members list
        Expanded(
          child: _filteredMembers.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _filteredMembers.length,
                  itemBuilder: (context, index) {
                    final member = _filteredMembers[index];
                    return FamilyMemberCardWidget(
                      member: member,
                      onEdit: () => _editMember(member),
                      onTestContact: () => _testContact(member),
                      onRemove: () => _removeMember(member),
                      onViewInheritedItems: () => _viewInheritedItems(member),
                      onSendTestAlert: () => _sendTestAlert(member),
                      onModifyAccess: () => _modifyAccess(member),
                      onChangeRelationship: () => _changeRelationship(member),
                    );
                  },
                ),
        ),

        // Bottom section with next notification info
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Next family notification: July 20, 2025',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _sendTestNotifications,
                      child: Text('Send Test Notifications'),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Manual notification triggered'),
                            backgroundColor: AppTheme.successLight,
                          ),
                        );
                      },
                      child: Text('Notify Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'family_restroom',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 4.h),
            Text(
              _searchQuery.isNotEmpty || _selectedFilter != 'All Members'
                  ? 'No family members match your search'
                  : 'No Family Members Added',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _searchQuery.isNotEmpty || _selectedFilter != 'All Members'
                  ? 'Try adjusting your search or filter criteria'
                  : 'Add family members to ensure your digital legacy is passed on securely. They will receive access to your passwords and accounts when needed.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isEmpty && _selectedFilter == 'All Members') ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: _showAddFamilyMemberDialog,
                icon: CustomIconWidget(
                  iconName: 'person_add',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text('Add First Family Member'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _editMember(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${member['name']}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _testContact(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Testing contact for ${member['name']}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _removeMember(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Family Member'),
          content: Text(
              'Are you sure you want to remove ${member['name']} from your family list? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _familyMembers.removeWhere((m) => m['id'] == member['id']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${member['name']} removed from family list'),
                    backgroundColor: AppTheme.errorLight,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
              ),
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _viewInheritedItems(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing inherited items for ${member['name']}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _sendTestAlert(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test alert sent to ${member['name']}'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _modifyAccess(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modifying access for ${member['name']}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _changeRelationship(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Changing relationship for ${member['name']}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
