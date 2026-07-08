import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'gradient_background.dart';

/// Every screen's outer shell: transparent Scaffold over the shared
/// [GradientBackground], with an optional transparent AppBar so the
/// blobs show through the whole surface instead of stopping at a solid
/// app bar band.
class GlassScaffold extends StatelessWidget {
  const GlassScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.leading,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: AppColors.textPrimary,
              actions: actions,
              leading: leading,
            ),
      body: GradientBackground(child: SafeArea(child: body)),
    );
  }
}
