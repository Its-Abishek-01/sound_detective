import 'package:flutter/material.dart';

/// Single source of truth for the glassmorphism palette. Every screen
/// pulls from here so the frosted-glass look stays consistent instead
/// of each widget picking its own opacity/blur values.
class AppColors {
  AppColors._();

  // Background gradient — deep indigo to violet, dark enough that
  // translucent glass panels read clearly against it.
  static const backgroundTop = Color(0xFF0B0E2A);
  static const backgroundMid = Color(0xFF201A3E);
  static const backgroundBottom = Color(0xFF32204F);

  // Soft blurred accent blobs floating behind the glass.
  static const blobViolet = Color(0xFF7F5AF0);
  static const blobPink = Color(0xFFFF6AC1);
  static const blobCyan = Color(0xFF3ED6C6);

  // Primary CTA gradient (the one non-glass, fully-opaque element).
  static const ctaStart = Color(0xFF8A5CF6);
  static const ctaEnd = Color(0xFFFF6AC1);

  // Glass panel fill/border/shadow.
  static const glassFill = Color(0x14FFFFFF); // ~8% white
  static const glassFillStrong = Color(0x22FFFFFF); // ~13% white
  static const glassBorder = Color(0x33FFFFFF); // ~20% white
  static const glassShadow = Color(0x40000000);

  // Text.
  static const textPrimary = Color(0xFFF6F4FF);
  static const textSecondary = Color(0xB3F6F4FF); // ~70%
  static const textTertiary = Color(0x80F6F4FF); // ~50%

  static const success = Color(0xFF3ED6C6);
  static const warning = Color(0xFFFFC876);
}
