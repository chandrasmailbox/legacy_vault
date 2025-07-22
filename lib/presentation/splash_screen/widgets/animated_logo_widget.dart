import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class AnimatedLogoWidget extends StatefulWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const AnimatedLogoWidget({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Start rotation animation with delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _rotationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF4A90E2).withAlpha(77),
                const Color(0xFF2E5266).withAlpha(26),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A90E2).withAlpha(77),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Transform.rotate(
            angle: _rotationAnimation.value * 3.14159,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer vault ring
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4A90E2),
                      width: 3,
                    ),
                  ),
                ),

                // Inner vault door
                Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2E5266),
                    border: Border.all(
                      color: const Color(0xFF4A90E2),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.security,
                    color: const Color(0xFF4A90E2),
                    size: 36.sp,
                  ),
                ),

                // Vault handle/dial
                Positioned(
                  top: 20.h,
                  child: Container(
                    width: 8.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
