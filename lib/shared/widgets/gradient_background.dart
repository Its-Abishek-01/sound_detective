import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The dark violet gradient + soft blurred color blobs every screen
/// sits on top of. Glassmorphism only reads as "glass" when there's
/// something with depth and color behind it to blur — a flat color
/// background would make every glass panel look like plain grey.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundTop,
                AppColors.backgroundMid,
                AppColors.backgroundBottom,
              ],
            ),
          ),
        ),
        Positioned(
          top: -120,
          left: -80,
          child: _Blob(color: AppColors.blobViolet, size: 320),
        ),
        Positioned(
          top: 180,
          right: -140,
          child: _Blob(color: AppColors.blobPink, size: 280),
        ),
        Positioned(
          bottom: -100,
          left: -60,
          child: _Blob(color: AppColors.blobCyan, size: 260),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
