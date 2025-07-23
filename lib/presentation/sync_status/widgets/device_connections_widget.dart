import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceConnectionsWidget extends StatefulWidget {
  const DeviceConnectionsWidget({Key? key}) : super(key: key);

  @override
  State<DeviceConnectionsWidget> createState() =>
      _DeviceConnectionsWidgetState();
}

class _DeviceConnectionsWidgetState extends State<DeviceConnectionsWidget> {
  final List<DeviceConnection> _mockConnections = [
    DeviceConnection(
      deviceName: 'iPhone 13 Pro',
      deviceType: 'iOS Device',
      connectionType: 'Bluetooth',
      isConnected: true,
      lastSync: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    DeviceConnection(
      deviceName: 'MacBook Pro',
      deviceType: 'Desktop',
      connectionType: 'Internet',
      isConnected: true,
      lastSync: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    DeviceConnection(
      deviceName: 'Nominee Device #1',
      deviceType: 'Android Phone',
      connectionType: 'Nearby',
      isConnected: false,
      lastSync: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_mockConnections.isEmpty)
          _buildEmptyState()
        else
          ..._mockConnections.map(
            (connection) => _buildConnectionItem(connection),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Icon(Icons.devices_other, size: 48, color: Colors.grey[400]),
          SizedBox(height: 2.h),
          Text(
            'No Connected Devices',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start a sync to discover nearby devices',
            style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionItem(DeviceConnection connection) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              connection.isConnected
                  ? const Color(0xFFA3BE8C).withAlpha(77)
                  : Colors.grey.withAlpha(77),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  connection.isConnected
                      ? const Color(0xFFA3BE8C).withAlpha(26)
                      : Colors.grey.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getDeviceIcon(connection.deviceType),
              color:
                  connection.isConnected
                      ? const Color(0xFFA3BE8C)
                      : Colors.grey,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      connection.deviceName,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E3440),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getConnectionTypeColor(
                          connection.connectionType,
                        ).withAlpha(51),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        connection.connectionType,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: _getConnectionTypeColor(
                            connection.connectionType,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  connection.deviceType,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Last sync: ${_formatLastSync(connection.lastSync)}',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  connection.isConnected
                      ? const Color(0xFFA3BE8C).withAlpha(26)
                      : Colors.grey.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color:
                        connection.isConnected
                            ? const Color(0xFFA3BE8C)
                            : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 1.w),
                Text(
                  connection.isConnected ? 'Online' : 'Offline',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        connection.isConnected
                            ? const Color(0xFFA3BE8C)
                            : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'ios device':
        return Icons.phone_iphone;
      case 'android phone':
        return Icons.phone_android;
      case 'desktop':
        return Icons.computer;
      case 'tablet':
        return Icons.tablet;
      default:
        return Icons.device_unknown;
    }
  }

  Color _getConnectionTypeColor(String connectionType) {
    switch (connectionType.toLowerCase()) {
      case 'bluetooth':
        return const Color(0xFF5E81AC);
      case 'internet':
        return const Color(0xFF88C0D0);
      case 'nearby':
        return const Color(0xFFD08770);
      default:
        return Colors.grey;
    }
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class DeviceConnection {
  final String deviceName;
  final String deviceType;
  final String connectionType;
  final bool isConnected;
  final DateTime lastSync;

  DeviceConnection({
    required this.deviceName,
    required this.deviceType,
    required this.connectionType,
    required this.isConnected,
    required this.lastSync,
  });
}
