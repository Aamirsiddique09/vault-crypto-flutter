import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF333539).withOpacity(0.4),
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          border: Border.all(
            color: const Color(0xFFB9CBBB).withOpacity(0.15),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
