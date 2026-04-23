// lib/widgets/background_wrapper.dart
import 'package:flutter/material.dart';
import 'package:gamerloop/constants/app_colors.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final String? imageUrl; // İleride CMS'den URL buraya gelecek

  const BackgroundWrapper({
    super.key,
    required this.child,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        image: DecorationImage(
          // EĞER imageUrl null ise asset resmini kullan, yoksa network image kullan
          image: imageUrl == null
              ? const AssetImage('assets/images/gamer_bg.jpg') as ImageProvider
              : NetworkImage(imageUrl!),
          fit: BoxFit.cover, // Resmi ekrana kapla
          // Arkaplanı biraz karartalım ki yazı net okunsun
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(child: child), // Çentiklere çarpmaması için SafeArea
    );
  }
}