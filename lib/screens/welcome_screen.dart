import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamerloop/app/session_manager.dart';
import 'package:gamerloop/constants/app_colors.dart';
import 'package:gamerloop/screens/login_screen.dart';
import 'package:gamerloop/widgets/background_wrapper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final Timer _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        imageAssetPath: 'assets/images/gamer_bg.png',
        showAmbientGlow: false,
        overlayOpacity: 0.42,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder<UserSession?>(
              valueListenable: SessionManager.currentUser,
              builder: (_, UserSession? user, __) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'HOŞGELDİN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    if (user != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        user.fullName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
