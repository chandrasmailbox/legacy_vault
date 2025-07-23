import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_filter_widget.dart';
import './widgets/password_card_widget.dart';
import './widgets/proof_of_life_banner_widget.dart';

class PasswordVault extends StatefulWidget {
  const PasswordVault({super.key});

  @override
  State<PasswordVault> createState() => _PasswordVaultState();
}

class _PasswordVaultState extends State<PasswordVault>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isRefreshing = false;

  // Mock data for password entries
  final List<Map<String, dynamic>> _passwordEntries = [
    {
      "id": 1,
      "serviceName": "Chase Bank",
      "username": "john.doe@email.com",
      "category": "Banking",
      "icon": "account_balance",
      "inheritanceStatus": "inherited",
      "lastUpdated": "2025-07-10",
      "isSecure": true,
    },
    {
      "id": 2,
      "serviceName": "Gmail",
      "username": "john.doe@gmail.com",
      "category": "Personal",
      "icon": "email",
      "inheritanceStatus": "restricted",
      "lastUpdated": "2025-07-08",
      "isSecure": true,
    },
    {
      "id": 3,
      "serviceName": "LinkedIn",
      "username": "johndoe",
      "category": "Work",
      "icon": "work",
      "inheritanceStatus": "inherited",
      "lastUpdated": "2025-07-05",
      "isSecure": true,
    },
    {
      "id": 4,
      "serviceName": "Facebook",
      "username": "john.doe.profile",
      "category": "Social",
      "icon": "people",
      "inheritanceStatus": "excluded",
      "lastUpdated": "2025-07-03",
      "isSecure": false,
    },
    {
      "id": 5,
      "serviceName": "Microsoft Office",
      "username": "j.doe@company.com",
      "category": "Work",
      "icon": "business",
      "inheritanceStatus": "inherited",
      "lastUpdated": "2025-07-12",
      "isSecure": true,
    },
    {
      "id": 6,
      "serviceName": "Amazon",
      "username": "johndoe2025",
      "category": "Personal",
      "icon": "shopping_cart",
      "inheritanceStatus": "restricted",
      "lastUpdated": "2025-07-11",
      "isSecure": true,
    },
  ];

  final List<String> _categories = [
    'All',
    'Banking',
    'Personal',
    'Work',
    'Social',
  ];

  List<Map<String, dynamic>> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _filteredEntries = _passwordEntries;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterEntries() {
    setState(() {
      _filteredEntries =
          _passwordEntries.where((entry) {
            final matchesSearch =
                _searchController.text.isEmpty ||
                (entry["serviceName"] as String).toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                (entry["username"] as String).toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

            final matchesCategory =
                _selectedCategory == 'All' ||
                entry["category"] == _selectedCategory;

            return matchesSearch && matchesCategory;
          }).toList();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  int _getCategoryCount(String category) {
    if (category == 'All') return _passwordEntries.length;
    return _passwordEntries
        .where((entry) => entry["category"] == category)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and tabs
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: Column(
                children: [
                  // App bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Legacy Vault',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/biometric-authentication-setup',
                            );
                          },
                          icon: CustomIconWidget(
                            iconName: 'settings',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _filterEntries(),
                      decoration: InputDecoration(
                        hintText: 'Search passwords...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'search',
                            color:
                                AppTheme
                                    .lightTheme
                                    .colorScheme
                                    .onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterEntries();
                                  },
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color:
                                        AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .onSurfaceVariant,
                                    size: 20,
                                  ),
                                )
                                : null,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.5.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Vault'),
                      Tab(text: 'Family'),
                      Tab(text: 'Settings'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab bar view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Vault tab content
                  _buildVaultContent(),

                  // Family tab placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'family_restroom',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Family Management',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/family-management');
                          },
                          child: const Text('Manage Family'),
                        ),
                      ],
                    ),
                  ),

                  // Settings tab placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'settings',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Settings',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/digital-will-setup');
                          },
                          child: const Text('Digital Will Setup'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _tabController.index == 0
              ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, '/add-edit-password');
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text('Add Password'),
              )
              : null,
    );
  }

  Widget _buildVaultContent() {
    return Column(
      children: [
        // Category filters
        CategoryFilterWidget(
          categories: _categories,
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
            _filterEntries();
          },
          getCategoryCount: _getCategoryCount,
        ),

        // Password list
        Expanded(
          child:
              _filteredEntries.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      itemCount: _filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _filteredEntries[index];
                        return PasswordCardWidget(
                          entry: entry,
                          onTap: () {
                            // Navigate to password detail screen
                            _showPasswordDetails(entry);
                          },
                          onEdit: () {
                            Navigator.pushNamed(context, '/add-edit-password');
                          },
                          onDelete: () {
                            _showDeleteConfirmation(entry);
                          },
                          onCopyPassword: () {
                            _copyToClipboard('Password copied');
                          },
                          onCopyUsername: () {
                            _copyToClipboard('Username copied');
                          },
                        );
                      },
                    ),
                  ),
        ),

        // Proof of life banner
        ProofOfLifeBannerWidget(
          nextCheckIn: DateTime.now().add(const Duration(days: 7)),
          onCheckIn: () {
            Navigator.pushNamed(context, '/proof-of-life-check-in');
          },
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
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.primary.withValues(
                alpha: 0.5,
              ),
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No passwords found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'Add your first password to get started',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            if (_searchController.text.isEmpty)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/add-edit-password');
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text('Add Your First Password'),
              ),
          ],
        ),
      ),
    );
  }

  void _showPasswordDetails(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: entry["icon"] as String,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 32,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry["serviceName"] as String,
                              style: AppTheme.lightTheme.textTheme.titleLarge,
                            ),
                            Text(
                              entry["username"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color:
                                        AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Actions
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(4.w),
                    children: [
                      _buildDetailAction(
                        icon: 'copy',
                        title: 'Copy Password',
                        onTap: () {
                          Navigator.pop(context);
                          _copyToClipboard('Password copied');
                        },
                      ),
                      _buildDetailAction(
                        icon: 'person',
                        title: 'Copy Username',
                        onTap: () {
                          Navigator.pop(context);
                          _copyToClipboard('Username copied');
                        },
                      ),
                      _buildDetailAction(
                        icon: 'edit',
                        title: 'Edit Password',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/add-edit-password');
                        },
                      ),
                      _buildDetailAction(
                        icon: 'share',
                        title: 'Share Access',
                        onTap: () {
                          Navigator.pop(context);
                          _showShareOptions();
                        },
                      ),
                      _buildDetailAction(
                        icon: 'refresh',
                        title: 'Generate New Password',
                        onTap: () {
                          Navigator.pop(context);
                          _generateNewPassword();
                        },
                      ),
                      _buildDetailAction(
                        icon: 'delete',
                        title: 'Delete Password',
                        isDestructive: true,
                        onTap: () {
                          Navigator.pop(context);
                          _showDeleteConfirmation(entry);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailAction({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color:
            isDestructive
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color:
              isDestructive
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Password'),
            content: Text(
              'Are you sure you want to delete the password for ${entry["serviceName"]}? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _passwordEntries.removeWhere((e) => e["id"] == entry["id"]);
                    _filterEntries();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password for ${entry["serviceName"]} deleted',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _copyToClipboard(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showShareOptions() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Share options coming soon')));
  }

  void _generateNewPassword() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('New password generated')));
  }
}
