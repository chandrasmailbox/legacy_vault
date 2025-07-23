import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/services/sync_service.dart';

class SyncStatusCard extends StatelessWidget {
  final SyncStatus status;
  final VoidCallback onSyncPressed;

  const SyncStatusCard({
    Key? key,
    required this.status,
    required this.onSyncPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _getStatusColor().withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withAlpha(77)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatusIcon(),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusText(),
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _getStatusDescription(),
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (status == SyncStatus.idle ||
                  status == SyncStatus.completed ||
                  status == SyncStatus.error)
                ElevatedButton(
                  onPressed: onSyncPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStatusColor(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                  ),
                  child: Text(
                    'Sync',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          if (status == SyncStatus.syncing) ...[
            SizedBox(height: 2.h),
            LinearProgressIndicator(
              backgroundColor: _getStatusColor().withAlpha(51),
              valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData iconData;

    switch (status) {
      case SyncStatus.idle:
        iconData = Icons.sync_disabled;
        break;
      case SyncStatus.initialized:
        iconData = Icons.sync_alt;
        break;
      case SyncStatus.syncing:
        iconData = Icons.sync;
        break;
      case SyncStatus.completed:
        iconData = Icons.sync_outlined;
        break;
      case SyncStatus.error:
        iconData = Icons.sync_problem;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getStatusColor().withAlpha(51),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: _getStatusColor(), size: 20),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case SyncStatus.idle:
        return Colors.grey;
      case SyncStatus.initialized:
        return const Color(0xFF88C0D0);
      case SyncStatus.syncing:
        return const Color(0xFF5E81AC);
      case SyncStatus.completed:
        return const Color(0xFFA3BE8C);
      case SyncStatus.error:
        return const Color(0xFFBF616A);
    }
  }

  String _getStatusText() {
    switch (status) {
      case SyncStatus.idle:
        return 'Ready to Sync';
      case SyncStatus.initialized:
        return 'Initialized';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.completed:
        return 'Sync Completed';
      case SyncStatus.error:
        return 'Sync Error';
    }
  }

  String _getStatusDescription() {
    switch (status) {
      case SyncStatus.idle:
        return 'Tap sync to start synchronization';
      case SyncStatus.initialized:
        return 'Sync service is ready';
      case SyncStatus.syncing:
        return 'Synchronizing data with connected devices';
      case SyncStatus.completed:
        return 'All data synchronized successfully';
      case SyncStatus.error:
        return 'Failed to synchronize data';
    }
  }
}
