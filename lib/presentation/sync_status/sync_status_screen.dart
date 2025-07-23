import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/models/sync_models.dart';
import '../../core/services/death_detection_service.dart';
import '../../core/services/inheritance_service.dart';
import '../../core/services/sync_service.dart';
import './widgets/device_connections_widget.dart';
import './widgets/heartbeat_status_widget.dart';
import './widgets/sync_status_card.dart';
import 'widgets/device_connections_widget.dart';
import 'widgets/heartbeat_status_widget.dart';
import 'widgets/sync_status_card.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({Key? key}) : super(key: key);

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
  final _syncService = SyncService();
  final _deathDetectionService = DeathDetectionService();
  final _inheritanceService = InheritanceService();

  SyncStatus _syncStatus = SyncStatus.idle;
  DeathDetectionState? _deathDetectionState;
  InheritanceStatus _inheritanceStatus = InheritanceStatus.idle;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupListeners();
  }

  Future<void> _initializeServices() async {
    try {
      await _syncService.initialize('user123', 'device456');
      await _deathDetectionService.initialize('user123');
    } catch (e) {
      _showError('Failed to initialize services: $e');
    }
  }

  void _setupListeners() {
    _syncService.syncStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _syncStatus = status;
        });
      }
    });

    _deathDetectionService.statusStream.listen((state) {
      if (mounted) {
        setState(() {
          _deathDetectionState = state;
        });
      }
    });

    _inheritanceService.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _inheritanceStatus = status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Sync & Inheritance Status',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E3440),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshStatus,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSyncSection(),
            SizedBox(height: 3.h),
            _buildHeartbeatSection(),
            SizedBox(height: 3.h),
            _buildInheritanceSection(),
            SizedBox(height: 3.h),
            _buildDeviceConnectionsSection(),
            SizedBox(height: 3.h),
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF5E81AC).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.sync,
                  color: Color(0xFF5E81AC),
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Sync Status',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E3440),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SyncStatusCard(status: _syncStatus, onSyncPressed: _performSync),
        ],
      ),
    );
  }

  Widget _buildHeartbeatSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFBF616A).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFBF616A),
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Death Detection',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E3440),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          HeartbeatStatusWidget(
            state: _deathDetectionState,
            onHeartbeatPressed: _updateHeartbeat,
          ),
        ],
      ),
    );
  }

  Widget _buildInheritanceSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD08770).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Color(0xFFD08770),
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Inheritance System',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E3440),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildInheritanceStatusCard(),
        ],
      ),
    );
  }

  Widget _buildInheritanceStatusCard() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (_inheritanceStatus) {
      case InheritanceStatus.ready:
        statusColor = const Color(0xFFA3BE8C);
        statusText = 'Ready';
        statusIcon = Icons.check_circle;
        break;
      case InheritanceStatus.triggered:
        statusColor = const Color(0xFFEBCB8B);
        statusText = 'Triggered';
        statusIcon = Icons.warning;
        break;
      case InheritanceStatus.activated:
        statusColor = const Color(0xFFBF616A);
        statusText = 'Activated';
        statusIcon = Icons.error;
        break;
      case InheritanceStatus.error:
        statusColor = const Color(0xFFBF616A);
        statusText = 'Error';
        statusIcon = Icons.error_outline;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Idle';
        statusIcon = Icons.circle;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          SizedBox(width: 2.w),
          Text(
            statusText,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
          const Spacer(),
          if (_inheritanceStatus == InheritanceStatus.idle)
            TextButton(
              onPressed: _setupInheritance,
              child: Text(
                'Setup',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceConnectionsSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF88C0D0).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.devices,
                  color: Color(0xFF88C0D0),
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Device Connections',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E3440),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          const DeviceConnectionsWidget(),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _performFullSync,
            icon: const Icon(Icons.sync, color: Colors.white),
            label: Text(
              'Perform Full Sync',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E81AC),
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _testEmergencyProtocol,
            icon: const Icon(Icons.warning, color: Colors.white),
            label: Text(
              'Test Emergency Protocol',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEBCB8B),
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _refreshStatus() async {
    setState(() {
      // Status will be updated through stream listeners
    });
  }

  Future<void> _performSync() async {
    try {
      await _syncService.startSync();
      _showSuccess('Sync completed successfully');
    } catch (e) {
      _showError('Sync failed: $e');
    }
  }

  Future<void> _performFullSync() async {
    try {
      await _syncService.startSync();
      _showSuccess('Full sync completed successfully');
    } catch (e) {
      _showError('Full sync failed: $e');
    }
  }

  Future<void> _updateHeartbeat() async {
    try {
      await _deathDetectionService.updateHeartbeat(
        metadata: {
          'location': 'Mobile App',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      _showSuccess('Heartbeat updated successfully');
    } catch (e) {
      _showError('Failed to update heartbeat: $e');
    }
  }

  Future<void> _setupInheritance() async {
    try {
      await _inheritanceService.setupInheritance(
        userId: 'user123',
        nomineeIds: ['nominee1', 'nominee2', 'nominee3'],
        masterPassword: 'master_password_123',
        threshold: 2,
        willData: {
          'message': 'This is my digital will',
          'instructions': 'Please distribute my assets as specified',
        },
      );
      _showSuccess('Inheritance setup completed');
    } catch (e) {
      _showError('Failed to setup inheritance: $e');
    }
  }

  Future<void> _testEmergencyProtocol() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Test Emergency Protocol',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'This will simulate an emergency scenario. Are you sure?',
              style: GoogleFonts.inter(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.inter()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _simulateEmergency();
                },
                child: Text(
                  'Confirm',
                  style: GoogleFonts.inter(color: const Color(0xFFBF616A)),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _simulateEmergency() async {
    _showSuccess('Emergency protocol test initiated');
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFA3BE8C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFBF616A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _syncService.dispose();
    _deathDetectionService.dispose();
    _inheritanceService.dispose();
    super.dispose();
  }
}
