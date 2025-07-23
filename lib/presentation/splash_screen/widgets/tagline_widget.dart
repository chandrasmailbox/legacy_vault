import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TaglineWidget extends StatefulWidget {
  final Animation<double> fadeAnimation;

  const TaglineWidget({super.key, required this.fadeAnimation});

  @override
  State<TaglineWidget> createState() => _TaglineWidgetState();
}

class _TaglineWidgetState extends State<TaglineWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuart),
    );

    // Start slide animation with delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: widget.fadeAnimation,
        child: Column(
          children: [
            Text(
              'Secure Digital Inheritance',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9CA3AF),
                letterSpacing: 0.8,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: 120.w,
              height: 1.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF4A90E2).withAlpha(153),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Protecting your legacy for generations',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
