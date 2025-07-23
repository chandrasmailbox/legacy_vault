import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/models/sync_models.dart';

class HeartbeatStatusWidget extends StatefulWidget {
  final DeathDetectionState? state;
  final VoidCallback onHeartbeatPressed;

  const HeartbeatStatusWidget({
    Key? key,
    required this.state,
    required this.onHeartbeatPressed,
  }) : super(key: key);

  @override
  State<HeartbeatStatusWidget> createState() => _HeartbeatStatusWidgetState();
}

class _HeartbeatStatusWidgetState extends State<HeartbeatStatusWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.state?.status == 'active') {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(HeartbeatStatusWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state?.status == 'active') {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == null) {
      return _buildLoadingState();
    }

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
              _buildHeartIcon(),
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
              ElevatedButton.icon(
                onPressed: widget.onHeartbeatPressed,
                icon: Icon(Icons.favorite, size: 16, color: Colors.white),
                label: Text(
                  'Heartbeat',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildStatusDetails(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          SizedBox(width: 3.w),
          Text(
            'Initializing death detection...',
            style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.state?.status == 'active' ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor().withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.favorite, color: _getStatusColor(), size: 20),
          ),
        );
      },
    );
  }

  Widget _buildStatusDetails() {
    return Column(
      children: [
        _buildDetailRow(
          'Last Heartbeat',
          _formatTimestamp(widget.state!.lastHeartbeat),
          Icons.access_time,
        ),
        SizedBox(height: 1.h),
        _buildDetailRow(
          'Check-in Interval',
          _formatDuration(widget.state!.checkInInterval),
          Icons.schedule,
        ),
        SizedBox(height: 1.h),
        _buildDetailRow(
          'Grace Period',
          _formatDuration(widget.state!.gracePeriod),
          Icons.timer,
        ),
        if (widget.state!.warningStarted != null) ...[
          SizedBox(height: 1.h),
          _buildDetailRow(
            'Warning Started',
            _formatTimestamp(widget.state!.warningStarted!),
            Icons.warning,
          ),
        ],
        if (widget.state!.deadManSwitchActivated != null) ...[
          SizedBox(height: 1.h),
          _buildDetailRow(
            'Dead Man Switch',
            _formatTimestamp(widget.state!.deadManSwitchActivated!),
            Icons.dangerous,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 2.w),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2E3440),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (widget.state?.status) {
      case 'active':
        return const Color(0xFFA3BE8C);
      case 'warning':
        return const Color(0xFFEBCB8B);
      case 'critical':
        return const Color(0xFFD08770);
      case 'confirmed':
        return const Color(0xFFBF616A);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (widget.state?.status) {
      case 'active':
        return 'Alive & Active';
      case 'warning':
        return 'Warning Period';
      case 'critical':
        return 'Critical State';
      case 'confirmed':
        return 'Death Confirmed';
      default:
        return 'Unknown Status';
    }
  }

  String _getStatusDescription() {
    switch (widget.state?.status) {
      case 'active':
        return 'Regular heartbeat detected';
      case 'warning':
        return 'Grace period has started';
      case 'critical':
        return 'Dead man\'s switch activated';
      case 'confirmed':
        return 'Inheritance process initiated';
      default:
        return 'Status information unavailable';
    }
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

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

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);

    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}
