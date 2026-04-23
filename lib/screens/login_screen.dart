// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:gamerloop/constants/app_colors.dart';
import 'package:gamerloop/widgets/background_wrapper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GİRİŞ / KAYIT',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Şimdilik taslak butonlar
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                child: const Text('Giriş Yap', style: TextStyle(color: Colors.black)),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accent)),
                child: const Text('Kayıt Ol', style: TextStyle(color: AppColors.accent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}