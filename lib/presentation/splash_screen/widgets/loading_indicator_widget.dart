import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class LoadingIndicatorWidget extends StatefulWidget {
  final Animation<double> fadeAnimation;

  const LoadingIndicatorWidget({
    super.key,
    required this.fadeAnimation,
  });

  @override
  State<LoadingIndicatorWidget> createState() => _LoadingIndicatorWidgetState();
}

class _LoadingIndicatorWidgetState extends State<LoadingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Start progress animation with delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: Column(
        children: [
          // Progress bar
          Container(
            width: 200.w,
            height: 4.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: const Color(0xFF2E5266),
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 200.w * _progressAnimation.value,
                    height: 4.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A90E2),
                          Color(0xFF63B8FF),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 16.h),

          // Loading text
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              String loadingText = 'Initializing...';
              if (_progressAnimation.value > 0.3) {
                loadingText = 'Securing vault...';
              }
              if (_progressAnimation.value > 0.6) {
                loadingText = 'Verifying access...';
              }
              if (_progressAnimation.value > 0.9) {
                loadingText = 'Ready!';
              }

              return Text(
                loadingText,
                style: TextStyle(
                  color: const Color(0xFF4A90E2),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
