// lib/widgets/background_wrapper.dart
import 'package:flutter/material.dart';
import 'package:gamerloop/constants/app_colors.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final String? imageAssetPath;
  final bool showAmbientGlow;
  final double overlayOpacity;

  const BackgroundWrapper({
    super.key,
    required this.child,
    this.imageAssetPath,
    this.showAmbientGlow = true,
    this.overlayOpacity = 0.22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageAssetPath == null)
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF07090F),
                    Color(0xFF0D111A),
                    Color(0xFF090B12),
                  ],
                ),
              ),
            )
          else
            Image.asset(
              imageAssetPath!,
              fit: BoxFit.cover,
            ),
          if (showAmbientGlow)
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.9,
                    colors: [
                      AppColors.accent.withOpacity(0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          if (showAmbientGlow)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Colors.blueAccent.withOpacity(0.14),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          Container(color: Colors.black.withOpacity(overlayOpacity)),
          SafeArea(child: child), // Çentiklere çarpmaması için SafeArea
        ],
      ),
    );
  }
}
